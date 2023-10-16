#!/bin/bash


echo "System information:"

cat /etc/redhat-release
g++ --version
conan --version

set -ex

conan list '*:*#*'

# Conan finds compatible b2 package in CCI, but that package is OS-incompatible 
conan install --requires=boost/1.82.0 --build=missing || echo "!!! (rc=$?) Build failed as expected"
conan list '*:*#*'

# Force source build, fill local cache with our version of b2
conan install --requires=boost/1.82.0 --build=missing --build='b2/*'
conan list '*:*#*'

# Force-build boost -- get the same error as in first run (as if our version of b2 doesn't exist)
conan install --requires=boost/1.82.0 --build='boost/*' || echo "!!! (rc=$?) Build should have succeeded, but it failed"
conan list '*:*#*'

# Remove offending CCI package
conan remove -c 'b2/*:*#a31a98f757dcf4d3f03ed629ccde26b7'
conan list '*:*#*'

# Force-build boost once again -- Conan resolves b2 to the only available local package
conan install --requires=boost/1.82.0 --build='boost/*'
conan list '*:*#*'

