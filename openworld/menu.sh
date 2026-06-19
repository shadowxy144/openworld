#!/bin/bash

anadizin=$(pwd)

while true
do

clear

cat << EOF

                             
  _____   ____   ____  __ __ 
 /     \_/ __ \ /    \|  |  \
|  Y Y  \  ___/|   |  \  |  /
|__|_|  /\___  >___|  /____/ 
      \/     \/     \/       
      
EOF

echo ""
echo "1) Verileri indir (Download data)"
echo ""
echo "2) Siteyi kur (Build the site)"
echo ""
echo "3) Nasıl kullanılır ? (how to use ?)"
echo ""

read -p "Seçim yap : " secim

if [[ "$secim" == "1" ]]; then

clear

echo "Gereken veriler indiriliyor lütfen bekleyin. (The necessary data is being downloaded, please wait.)"


{ sudo apt update && sudo apt upgrade -y; } > /dev/null 2>&1 &
wait

clear

{

    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
    
  
    sudo apt update
    sudo apt install -y cloudflared
} > /dev/null 2>&1 & 



clear



echo "Gereken veriler indirildi menüye aktarılıyorsunuz (The necessary data has been downloaded and you are being transferred to the menu.)"

sleep 2


continue


elif [[ "$secim" == "2" ]]; then

while true
do

clear

cat << EOF


  _____.__                        
_/ ____\  | _____ _______   ____  
\   __\|  | \__  \\_  __ \_/ __ \ 
 |  |  |  |__/ __ \|  | \/\  ___/ 
 |__|  |____(____  /__|    \___  >
                 \/            \/ 


EOF

echo ""
echo "1) Siteyi kur (Setup site)"
echo ""
echo "2) Menüye geri dön (return to menu)"
echo ""

read -p "Seçim yap : " secim2

if [[ "$secim2" == "1" ]]; then

clear


read -p "Lütfen bir dizin girin (Please enter a directory.): " dizin 

cd "$dizin" || { clear; echo "Lütfen farklı bir dizin girin (Please enter a different directory.)"; sleep 2; continue; }


clear

read -p "Lütfen bir port girin (Please enter a port): " port

python3 -m http.server "$port" > /dev/null 2>&1 &

clear

echo "Local adresiniz (Your local address) : localhost:$port"
echo ""
echo "Siteniz dış dünyaya açılıyor (Your site is going out to the outside world.)"
echo ""

cloudflared tunnel --url localhost:$port > "$anadizin/cloudflare.txt" 2>&1 &

sleep 10

site=$(grep -o 'https://[a-zA-Z0-9-]*\.trycloudflare\.com' "$anadizin/cloudflare.txt")

clear

echo "Siteniz (your site) : "$site" "
echo ""
echo "Menüye dönmek için entere basın (Press Enter to return to the menu.)"
echo ""

read -p "Enter..."

pkill -f "python3 -m http.server $port"
pkill -f "cloudflared tunnel --url localhost:$port"

continue


elif [[ "$secim2" == "2" ]]; then

break



else

clear
echo "Lütfen farklı bir seçim yapın (Please choose a different option.)"
sleep 2
continue

fi
done

elif [[ "$secim" == "3" ]]; then

clear


cat "$anadizin/how.txt"

read -p "Menüye dönmek için entere basın"

continue

else

clear
echo "Lütfen farklı bir seçim yapın (Please choose a different option.)"
sleep 2
continue

fi
done
