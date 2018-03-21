import hashlib
import hmac
import urllib2
import urllib
import time
import ssl

access_key = '00000000000000000000000000'
secret_key = '00000000000000000000000000'

# 0. making ssl context - verify should be turned off
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

# ------------------
# Get markets list
# ------------------

# 1. list markets
epoch_time = str(int(time.time())) + '000'
request = 'access_key=' + access_key + '&tonce=' + epoch_time
message = 'GET|/api/v2/markets|' + request

# 1.1 generate the hash.
signature = hmac.new(
    secret_key,
    message,
    hashlib.sha256
).hexdigest()

# 1.2 list markets
query = 'https://graviex.net/api/v2/markets?' + request + '&signature=' + signature
content = urllib2.urlopen(query, context=ctx).read()
print(content)

# ------------------
# Put sell order
# ------------------

# 2. put order
epoch_time = str(int(time.time())) + '001' # tonce should be different from previous one

request = 'access_key=' + access_key + '&market=giobtc&price=0.000000042&side=sell' + '&tonce=' + epoch_time + '&volume=100.0'
message = 'POST|/api/v2/orders|' + request

# 2.1 generate the hash.
signature = hmac.new(
    secret_key,
    message,
    hashlib.sha256
).hexdigest()

# 2.2 put order
query = 'https://graviex.net/api/v2/orders?' + request
result = urllib2.Request(query, urllib.urlencode({'signature' : signature})) #there is a trick - we need a POST request, thats why urlencode used
content = urllib2.urlopen(result, context=ctx).read()
print(content)

