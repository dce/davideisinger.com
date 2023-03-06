#!/usr/bin/env bash

export HUGOxPARAMSxGITxLAST_COMMITxAUTHORNAME=$(git log -1 --format=%an)
export HUGOxPARAMSxGITxLAST_COMMITxDATE=$(git log -1 --format=%cI)
export HUGOxPARAMSxGITxLAST_COMMITxHASH=$(git log -1 --format=%H)
export HUGOxPARAMSxGITxLAST_COMMITxSUBJECT=$(git log -1 --format=%s)
