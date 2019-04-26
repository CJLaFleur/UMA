import subprocess
import paramiko
import multiprocessing as mp
from multiprocessing import Queue, Process

class Nimbus:
    # Class Variables
    package = ""
    version = ""
    package