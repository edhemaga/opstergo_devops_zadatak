#!/bin/bash  
  
#!/bin/bash
input="data.txt"
while IFS= read -r line
do
  echo "$line"
done < "$input"