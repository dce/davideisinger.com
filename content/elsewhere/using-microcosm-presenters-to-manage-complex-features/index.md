---
title: "Using Microcosm Presenters to Manage Complex Features"
date: 2017-06-14T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/using-microcosm-presenters-to-manage-complex-features/
---

We made [Microcosm](http://code.viget.com/microcosm/) to help us manage
state and data flow in our JavaScript applications. We think it's
pretty great. We recently used it to help our friends at
[iContact](https://www.icontact.com/) launch a [brand new email
editor](https://www.icontact.com/big-news). Today, I'd like to show you
how I used one of my favorite features of Microcosm to ship a
particularly gnarly feature.

In addition to adding text, photos, and buttons to their emails, users
can add *code blocks* which let them manually enter HTML to be inserted
into the email. The feature in question was to add server-side code
santization, to make sure user-submitted HTML isn't invalid or
potentially malicious. The logic is roughly defined as follows:

-   User modifies the HTML & hits "preview";
-   HTML is sent up to the server and sanitized;
-   The resulting HTML is displayed in the canvas;
-   If the code is unmodified, user can "apply" the code or continue
    editing;
-   If the code is modified, user can "apply" the modified code or
    "reject" the changes and continue editing;
-   If at any time the user unfocuses the block, the code should return
    to the last applied state.

Here's a flowchart that might make things clearer (did for me, in any
event):

{{<dither URfAcl9.png />}}

This feature is too complex to handle with React component state, but
too localized to store in application state (the main Microcosm
instance). Fortunately, Microcosm gives us the perfect tool to handle
this scenario:
[Presenters](http://code.viget.com/microcosm/api/Presenter.html).

Using a Presenter, we can build an app-within-an-app, with a unique
domain, actions, and state, and communicate with the main repository as
necessary.

First, we define some
[Actions](http://code.viget.com/microcosm/api/actions.html) that only
pertain to this Presenter:

```javascript
const changeInputHtml = html => html
const acceptChanges = () => {}
const rejectChanges = () => {}
```

We don't export these functions, so they only exist in the context of
this file.

Next, we'll define the Presenter itself:

```javascript
class CodeEditor extends Presenter {
  setup(repo, props) {
    repo.addDomain('html', {
      getInitialState() {
        return {
          originalHtml: props.block.attributes.htmlCode,
          inputHtml: props.block.attributes.htmlCode,
          unsafeHtml: null,
          status: 'start'
        }
      },
```

The `setup` function is invoked when the Presenter is created. It
receives a fork of the main Microcosm repo as its first argument. We
invoke the
[`addDomain`](http://code.viget.com/microcosm/api/microcosm.html#adddomainkey-config-options)
function to add a new domain to the forked repo. The main repo will
never know about this new bit of state.

Now, let's instruct our new domain to listen for some actions:

```javascript
      register() {
        return {
          [scrubHtml]: this.scrubSuccess,
          [changeInputHtml]: this.inputHtmlChanged,
          [acceptChanges]: this.changesAccepted,
          [rejectChanges]: this.changesRejected
        }
      },
```

The
[`register`](http://code.viget.com/microcosm/api/domains.html#register)
method defines the mapping of Actions to handler functions. You should
recognize those actions from the top of the file, minus `scrubHtml`,
which is defined in a separate API module.

Now, still inside the domain object, let's define some handlers:

```javascript
      inputHtmlChanged(state, inputHtml) {
        let status = inputHtml === state.originalHtml ? 'start' : 'changed'

        return { ...state, inputHtml, status }
      },
      
      scrubSuccess(state, { html, modified }) {
        if (modified) {
          return {
            ...state,
            status: 'modified',
            unsafeHtml: state.inputHtml,
            inputHtml: html
          }
        } else {
          return { ...state, status: 'validated' }
        }
      },
```

Handlers always take `state` as their first object and must return a new
state object. Now, let's add some more methods to our main `CodeEditor`
class.

```javascript
  renderPreview = ({ html }) => {
    this.send(updateBlock, this.props.block.id, {
      attributes: { htmlCode: html }
    })
  }
  
  componentWillUnmount() {
    this.send(updateBlock, this.props.block.id, {
      attributes: { htmlCode: this.repo.state.html.originalHtml }
    })
  }
```

Couple cool things going on here. The `renderPreview` function uses
[`this.send`](http://code.viget.com/microcosm/api/presenter.html#sendaction-...params)
to send an action to the main Microcosm instance, telling it to update
the canvas with the given HTML. And `componentWillUnmount` is noteworthy
in that it demonstrates that Presenters are just React components under
the hood.

Next, let's add some buttons to let the user trigger these actions.

```javascript
  buttons(status, html) {
    switch (status) {
      case 'changed':
        return (
          <div styleName="buttons">
            <ActionButton
              action={scrubHtml}
              value={html}
              onDone={this.renderPreview}
            >
              Preview changes
            </ActionButton>
          </div>
        )
      case 'validated':
        return (
          <div styleName="buttons">
            <ActionButton action={acceptChanges}>
              Apply changes
            </ActionButton>
          </div>
        )
      // ...
```

The
[ActionButton](http://code.viget.com/microcosm/api/action-button.html)
component is pretty much exactly what it says on the tin --- a button
that triggers an action when pressed. Its callback functionality (e.g.
`onOpen`, `onDone`) lets you update the button as the action moves
through its lifecycle.

Finally, let's bring it all home and create our model and view:

```javascript
  getModel() {
    return {
      status: state => state.html.status,
      inputHtml: state => state.html.inputHtml
    }
  }

  render() {
    const { status, inputHtml } = this.model
    const { name } = this.props

    return (
      <div>
        {this.buttons(status, inputHtml)}

        <textarea
          id={name}
          name={name}
          value={inputHtml}
          onChange={e => this.repo.push(changeInputHtml, e.target.value)}
          disabled={status === 'modified'}
          styleName="textarea"
        />
      </div>
    )
  }
}
```

The
[docs](http://code.viget.com/microcosm/api/presenter.html#getmodelprops-state)
explain `getModel` better than I can:

> `getModel` assigns a model property to the presenter, similarly to
> `props` or `state`. It is recalculated whenever the Presenter's
> `props` or `state` changes, and functions returned from model keys are
> invoked every time the repo changes.

The `render` method is pretty straightahead React, though it
demonstrates how you interact with the model.

------------------------------------------------------------------------

The big takeaways here:

**Presenters can have their own repos.** These can be defined inline (as
I've done) or in a separate file/object. I like seeing everything in
one place, but you can trot your own trot.

**Presenters can manage their own state.** Presenters receive a fork of
the main app state when they're instantiated, and changes to that state
(e.g. via an associated domain) are not automatically synced back to the
main repo.

**Presenters can use `send` to communicate with the main repository.**
Despite holding a fork of state, you can still use `this.send` (as we do
in `renderPreview` above) to push changes up the chain.

**Presenters can have their own actions.** The three actions defined at
the top of the file only exist in the context of this file, which is
exactly what we want, since that's the only place they make any sense.

**Presenters are just React components.** Despite all this cool stuff
we're able to do in a Presenter, under the covers, they're nothing but
React components. This way you can still take advantage of lifecycle
methods like `componentWillUnmount` (and `render`, natch).

------------------------------------------------------------------------

So those are Microcosm Presenters. We think they're pretty cool, and
hope you do, too. If you have any questions, hit us up on
[GitHub](https://github.com/vigetlabs/microcosm) or right down there.
