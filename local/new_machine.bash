echo "Get backup of AGENT.md on existing machine"
scp mai:/home/knutfd/dev/AGENT.md .  || true

echo "Deleting existing machine..."
ssh metai delete -y

echo "Creating a new machine, but unfortunately you have to confirm with interactive commands :-("
ssh metai create https://github.com/knutfrode/met-dev-setup.git 2>&1 | tee new_machine.log

ip=`grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' new_machine.log | tail -1`
echo "Knut-Frode's magical script has detected that the new user-facing IP is: $ip"
sed -i "/^Host mai$/,/^    Hostname / s/^    Hostname .*/    Hostname $ip/" ~/.ssh/config
echo "IP should hopefully be successfully updated in ~/.ssh/config:"
grep "Host mai" ~/.ssh/config -A 1
echo "So now you can grab a coffee while waiting for the machine to be up and running."

