# 1.show list
# 2.add to lists
# 3.remove from lists
import os
def main():
    while(True):
        print("\nPlease Select Action number")
        print("\t1.show list |  2.add to lists | 3.remove from lists | 4.Quit")
        print("\t----------------------------------")
        select = input("\nEnter action: ")
        path = "/mnt/d/repository/ansiblelinuxaccount/code/python/Zimbra-add-blacklist/blacklist.txt"
       # path = "/opt/zimbra/conf/blacklist"
        if select == "1":
            print("1.show list\n")
            blacklistfile = open(path, "r")
            print(blacklistfile.read())
            blacklistfile.close()
            main()
        elif select == "2":
            print("2.add to lists\n")
            blacklistaddress = input("Enter blacklist address: ")
            blacklistfile = open(path, "a+")
            blacklistfile.write(blacklistaddress + "\n")
            print("add " + blacklistaddress + " to Blacklists files")
            blacklistfile.close()
            restartservice = input("Restart service now? : ")
            if restartservice =='y':
                os.system('sudo su - zimbra -c "zmamavisdctl restart"')
            else:
                main()    
        elif select == "3":
            print("3.remove from lists\n")
            print("\n use command nano" +path+ "and remove what you want\n ")
            print("\n use command sudo su - zimbra -c \"zmamavisdctl restart\" to restart service ")
            blacklistads = input("Enter blacklist address: ")
            command = "sed  -i 's/"+blacklistads+"/g'"+path
            print(command)
            os.system(command)
            main()
        else:
            print("end")
            exit(0)
main()