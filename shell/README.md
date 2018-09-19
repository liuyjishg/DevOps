

mkdir -p Clean_log_script  && touch Clean_log_script/{clean_log.log,tar_log.sh,for.sh}  && cd Clean_log_script  && chmod +x ./*.sh 


echo "echo " >> ~/.bash_profile
echo "tail /home/svcaccttomcat/Clean_log_script/clean_log.log" >> ~/.bash_profile
echo "echo " >> ~/.bash_profile


50 1 * * *  sh /home/svcaccttomcat/Clean_log_script/tar_log.sh &>/dev/null

