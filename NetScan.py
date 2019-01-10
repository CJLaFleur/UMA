import socket
from subprocess import Popen, PIPE


class Network:
    # Class variables
    IPnetwork = ""
    StartIP = ""
    EndIP = ""
    IPrange = []
    ActiveIPs = []
    Hostnames = []

    # Get IP range
    def getiprange(self):
        self.IPnetwork = input("Enter an IP network (xxx.xxx.x): ")
        self.StartIP = input("Enter a start IP: ")
        self.StartIP = int(self.StartIP)
        self.EndIP = input("Enter an end IP: ")
        self.EndIP = int(self.EndIP)
        while self.StartIP <= self.EndIP:
            temp = str(self.StartIP)
            self.IPrange.append(str(self.IPnetwork) + "." + temp)
            self.StartIP += 1

    # Get active hosts
    def gethosts(self):
        for ip in self.IPrange:
            ip = str(ip)
            toping = Popen(['ping', '-c', '1', '-i', '0.1', ip], stdout=PIPE)
            output = toping.communicate()[0]
            hostalive = toping.returncode
            if hostalive == 0:
                self.ActiveIPs.append(ip)

    # Get host names
    def gethostnames(self):
        for x in self.ActiveIPs:
            self.Hostnames.append(socket.getfqdn(x))

    # Print active hosts
    def printhosts(self):
        x = 0
        while x < len(self.Hostnames):
            print(self.ActiveIPs[x], " ", self.Hostnames[x])
            x += 1


Scan: Network = Network()

Scan.getiprange()

Scan.gethosts()

Scan.gethostnames()

Scan.printhosts()
