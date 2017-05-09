# Setup

Install Python 3.6 and pip3 via Brew. Install Mongod and set it running in the background.

Run `pip3 install -r requirements.txt` to install packages necessary.
If adding new libraries, make sure to install pipreqs and run `pipreqs .` on the Backend directory.

Note for the future, let's keep end points organised under `/api/v1` so we can keep a distinction on api versions for the future and prevent a shitstorm of old devices from breaking on any large changes.

:v::v::v: