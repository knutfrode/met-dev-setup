echo "Get backup of md-files from existing machine"
timeout 5 scp mai:/home/knutfd/dev/*.md .  || true

echo "Deleting existing machine..."
ssh metai delete -y

echo "Creating a new machine, automatically accepting"
echo "y" | ssh metai create https://github.com/knutfrode/met-dev-setup.git 2>&1 | tee new_machine.log

ip=`grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' new_machine.log | tail -1`
echo "Knut-Frode's magical script has detected that the new user-facing IP is: $ip"
sed -i "/^Host mai$/,/^    Hostname / s/^    Hostname .*/    Hostname $ip/" ~/.ssh/config
echo "IP should hopefully be successfully updated in ~/.ssh/config:"
grep "Host mai" ~/.ssh/config -A 1

echo "Waiting 5 minutes, then trying each minute to log in until successful"
sleep 300 && until echo "yes" | ssh mai; do sleep 60; done
# User must here enter password twice, but this could in principle be grabbed from a .netrc file?
echo "Yohoo, machine is up and running!"

echo "Uploading backup of md-files to new machine"
scp *.md mai:/home/knutfd/dev/  || true

echo "Uploading darpa trajectory data"
scp ~/software/2024_drift_in_the_ocean_with_ml_blue_follow_up_darpa/data/spotter_data/spotter_data_bulk_trajan_trajectories_to_use_hourly.nc mai:/home/knutfd/dev/darpa/

echo "Uploading forcing data"
scp ~/software/2024_drift_in_the_ocean_with_ml_blue_follow_up_darpa/predictors/predictor_offline_mercator.nc mai:/home/knutfd/dev/darpa/
scp ~/software/2024_drift_in_the_ocean_with_ml_blue_follow_up_darpa/predictors/predictor_offline_cmemswind.nc mai:/home/knutfd/dev/darpa/


echo "Logging in and ready to go!"
ssh mai
