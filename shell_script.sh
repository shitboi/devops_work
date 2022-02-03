if [ $# -eq 0 ]
then  
    echo "No month number given"
    exit

else
    if [ $1 -gt 12 ] || [ $1 -lt 1 ]  
    then
        echo "Invalid month number given"
        exit
    else
        if [ $1 = 1 ]
        then
            echo "January"
        elif [ $1 = 2 ]
        then
            echo "February"
        elif [ $1 = 3 ]
        then
            echo "March"
        elif [ $1 = 4 ]
        then
            echo "April"
        elif [ $1 = 5 ]
        then
            echo "May"
        elif [ $1 = 6 ]
        then
            echo "June"
        elif [ $1 = 7 ]
        then
            echo "July"
        elif [ $1 = 8 ]
        then
            echo "August"
        elif [ $1 = 9 ]
        then
            echo "September"
        elif [ $1 = 10 ]
        then
            echo "October"
        elif [ $1 = 11 ]
        then
            echo "November"
        elif [ $1 = 12 ]
        then
            echo "December"
        fi
    fi
fi