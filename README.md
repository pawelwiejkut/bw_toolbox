# BW Toolbox 📊 🔨 📦

[![YourActionName Actions Status](https://github.com/pawelwiejkut/bw_toolbox/workflows/CI/badge.svg)](https://github.com/pawelwiejkut/bw_toolbox/actions)

Welcome at github BW Toolbox page, fell free to contribute and create pull requests.

## What is inside ?

Inside you can found a special collection of reports, methods and interfaces containing all necessary tools for daily work in SAP BW.

-main report with aggregation of usefull standard reports:

![Screenshot](https://i.imgur.com/hkBg7FU.png)

Activate:
- activate transformation / RSDG_TRFN_ACTIVATE
- activate data source / RSDS_DATASOURCE_ACTIVATE_ALL
- activate DTP / RSBKDTPREPAIR
- activate composite provider RSDG_HCPR_ACTIVATE
- activate infocube / RSDG_CUBE_ACTIVATE

Maitenance:
- change DTP request status / RSBM_GUI_CHANGE_USTATE
- re-import objects / RSDG_AFTER_IMPORT_FOR_CORR
- delete process chain variant / based on RSPC_VARIANT_DELETE
- start process chain / RSPC_API_CHAIN_START
- drop openhub tables / based on DB_DROP_TABLE
- repair infoobjects / RSDG_IOBJ_REORG
- process chain variant status change / based on RSPC_PROCESS_FINISH
- unlock user / based on BAPI_USER_UNLOCK

Classic view:
- DTP / rsbk0001
- Transformation / rstran_gui_start
- Datasource / transaction RSDS
- Infoprovider / transaction RSOADSO

interfaces:
- start/end/expert routine interface

methods for every day development:
- get end of month
- check request status
- check open file authorization
- check process chain statistics
- remove whitespace
- remove newline char

## How to install
Clone this repository using [ABAP Git](https://github.com/larshp/abapGit)

## How to contribute ?

Please check [this link](https://pawelwiejkut.net/how-to-contribute-abap-projects-on-github/) or contribution page.

