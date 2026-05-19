echo "Get backup of AGENT.md on existing machine"
scp mai:/home/knutfd/dev/AGENT.md .  || true

echo "Deleting existing machine..."
ssh metai delete -y

echo "Creating a new machine, but unfortunately you have to confirm with interactive commands :-("
ssh metai create https://github.com/knutfrode/met-dev-setup.git 2>&1 | tee new_machine.log
# User must here confirm interactively - perhaps metai create could be updated to accept -y ?

ip=`grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' new_machine.log | tail -1`
echo "Knut-Frode's magical script has detected that the new user-facing IP is: $ip"
sed -i "/^Host mai$/,/^    Hostname / s/^    Hostname .*/    Hostname $ip/" ~/.ssh/config
echo "IP should hopefully be successfully updated in ~/.ssh/config:"
grep "Host mai" ~/.ssh/config -A 1

echo "Waiting 5 minutes, then trying each minute to log in until successful"
sleep 300 && until ssh mai; do sleep 60; done
# User must here enter password twice
echo "Yohoo, machine is up and running!"

echo "Uploading backup of AGENT.md to new machine"
scp AGENT.md mai:/home/knutfd/dev/  || true

echo "Logging in and ready to go!"
ssh mai
