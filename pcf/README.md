This script will fetch all tiles needed for the Elastic Runtime lab and upload them to Ops Manager.

You need to set the following environment variables to use this script:
  * piv_net_token
  * ops_man_username
  * ops_man_password
  
```bash
piv_net_token=abc1234 ops_man_username=admin ops_man_password=xyz789 ./fetch_tiles.sh
```