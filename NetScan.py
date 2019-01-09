import socket
import ipaddress
from subprocess import Popen, PIPE


class Network:
    # Class variables
    IPrange = ""
    ActiveIPs = []
    Hostnames = []

    # Get IP range
    def getiprange(self):
        self.IPrange = ipaddress.ip_network(input("Enter an IP network to scan (xxx.xxx.x.x/xx)"))
        print("check1")

    # Get active hosts
    def gethosts(self):
        for i in self.IPrange.hosts():
            i = str(i)
            toping = Popen(['ping', '-c', '1', '-i', '0.1', i], stdout=PIPE)
            output = toping.communicate()[0]
            hostalive = toping.returncode
            if hostalive == 0:
                self.ActiveIPs.append(i)
                print("check2")

    # Get host names
    def gethostnames(self):
        for x in self.ActiveIPs:
            self.Hostnames.append(socket.gethostbyaddr(x))
            print("check3")

    # Print active hosts
    def printhosts(self):
        x = 0
        while x < len(self.Hostnames):
            print(self.ActiveIPs[x], " ", self.Hostnames[x])
            x += 1
            print("check4")


Scan: Network = Network()

Scan.getiprange()

Scan.gethosts()

Scan.gethostnames()

Scan.printhosts()
