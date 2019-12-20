'''
    About   : Try to monitor the procs and files num during your job
    Usage   : sh Get_thr_filenum.sh username jobname;
              i.e.   $sleep 2000$
              you should exec  as: sh Get_thr_filenum.sh username 2000 or sh Get_thr_filenum.sh username sleep
           
    
    Returns : average or max procs or files you use during the executing of your job
'''

function fthrNumperproc()
    {
       #echo $pid
        thr_num=`pstree -p $pid | wc -l`
        return $((thr_num))
    }
function fexit_script(){
    exit -1
}

function fsumThr()
 {
     # echo $1,$2
     s=`pgrep -u $1 -f $2`
     proc_name=($s)
     proc_num=${#proc_name[@]}
     # echo $proc_num
     if [ $proc_num -eq 0 ];then
      fexit_script
     fi

     thr_sum=0
     for pid in ${proc_name[@]}
        do
            fthrNumperproc ${pid}
            thr_num=$?
            thr_sum=$(($thr_num + $thr_sum))
        done

      return $thr_sum;
 }
fsumThr $1 $2
thr_num=$?
s_files=`lsof -wn|awk '{print $1}'|sort|uniq -c|sort -nr|more|grep java`
num_files=($s_files)
part1= 

#while [ ${thr_num} -ne -1 ];
while [[ "$num_files" -ne "$part1" ]]
do
    #sleep 5s;
    s_files=`lsof -wn|awk '{print $1}'|sort|uniq -c|sort -nr|more|grep java`;num_files=($s_files)
    # echo $num_files
    # echo $thr_num
    echo "${thr_num}" >> thr_use.tsv;
    echo "${num_files}" >> files_use.tsv;
    fsumThr $1 $2;
    thr_num=$?;
done
# cat thr_use.tsv|awk '{sum+=$1} END {print "Averagethr = ", sum/NR}';
# cat thr_use.tsv|awk 'BEGIN {max = 0} {if ($1+0>max+0) max=$1 fi} END {print "Max_thr=", max}';
# cat files_use.tsv|awk '{sum+=$1} END {print "Averagefiles = ", sum/NR}';
# cat files_use.tsv|awk 'BEGIN {max = 0} {if ($1+0>max+0) max=$1 fi} END {print "Max_files=", max}';
