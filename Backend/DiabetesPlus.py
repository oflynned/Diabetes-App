import sys

from app import app

mode = "dev"

if __name__ == '__main__':
    if len(sys.argv) > 1:
        env = sys.argv[1]
        if env == "prod":
            mode = "prod"
            # remember to run only over SSL for iOS
            app.run(ssl_context=('neurobranchbeta.pem'),host='0.0.0.0', port=443)
    else:
        app.run(host='0.0.0.0', port=3000)
