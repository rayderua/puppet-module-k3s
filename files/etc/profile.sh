# Add /var/lib/rancher/k3s/data/current/bin to the path for sh compatible users

if [ -z "${PATH-}" ] ; then
  export PATH=/var/lib/rancher/k3s/data/current/bin
elif ! echo "${PATH}" | grep -q /var/lib/rancher/k3s/data/current/bin ; then
  export PATH="${PATH}:/var/lib/rancher/k3s/data/current/bin"
fi
