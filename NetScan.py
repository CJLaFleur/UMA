import multiprocessing as mp
import socket
from subprocess import Popen, PIPE


class Network:
    # Class variables
    IPnetwork = ""
    StartIP = ""
    EndIP = ""
    IPrange = mp.Queue()
    ActiveIPs = mp.Queue()
    Hostnames = mp.Queue()

    # Get IP range
    def getiprange(self):
        self.IPnetwork = input("Enter an IP network (xxx.xxx.x): ")
        self.StartIP = input("Enter a start IP: ")
        self.StartIP = int(self.StartIP)
        self.EndIP = input("Enter an end IP: ")
        self.EndIP = int(self.EndIP)
        while self.StartIP <= self.EndIP:
            temp = str(self.StartIP)
            self.IPrange.put(str(self.IPnetwork) + "." + temp)
            self.StartIP += 1

    # Get active hosts
    def gethosts(self):
        while not self.IPrange.empty():
            ip = self.IPrange.get()
            toping = Popen(['ping', '-c', '1', '-i', '0.1', ip], stdout=PIPE)
            output = toping.communicate()[0]
            hostalive = toping.returncode
            if hostalive == 0:
                self.ActiveIPs.put(ip)

    # Get host names
    def gethostnames(self):
        while not self.ActiveIPs.empty():
            ip = self.ActiveIPs.get()
            hostn = socket.getfqdn(ip)
            temp = hostn + "\t " + ip
            self.Hostnames.put(temp)

    # Print active hosts
    def printhosts(self):
        while not self.Hostnames.empty():
            print(self.Hostnames.get())



Scan: Network = Network()

Scan.getiprange()

Scan.gethosts()

Scan.gethostnames()

Scan.printhosts()