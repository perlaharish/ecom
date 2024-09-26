component=payment
rabbit_mq_pass=$1
if [ -z ${rabbit_mq_pass} ]; then
  echo "Imported Password missing"
  exit
  fi
source comman.sh
func_python

