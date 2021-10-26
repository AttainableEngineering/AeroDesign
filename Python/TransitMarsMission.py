import datetime

def TextToSecs(text):
    words = text.split(" ")
    nums = [ii for ii in words[0::2]]
    if len(nums) == 4:
        day, hour, min, sec = nums
    elif len(nums) == 3:
        hour, min, sec = nums
        day = 0
    else:
        print("\n\nUnexpected case...\n\n")
    secs = float(sec) + 60*int(min) + 60*60*int(hour) + 24*60*60*int(day)
    return secs

def SecsToText(secs):  
    day = secs/86400
    days = day // 1 #### floor day
    year = day/365
    years = year // 1 #### floor year
    hour = (day-days)*24
    hours = hour//1   ### floor hour
    minute = (hour-hours)*60
    minutes = minute//1
    seconds = (minute - minutes)*60

    if years == 0 and days == 0:
        print(f"Trip Time: {int(hours)} hours, {int(minutes)} minutes, {seconds} seconds.\n")
    elif years == 0:
        print(f"Trip Time: {int(days)} days, {int(hours)} hours, {int(minutes)} minutes, {seconds} seconds.\n")
    else:
        print(f"Trip Time: {int(years)} years, {int(days)} days, {int(hours)} hours, {int(minutes)} minutes, {seconds} seconds.\n")

class MarsToMoonsTrip:
    '''
    \nClass to represent a trip to Mars's Moons.
    \nPurpose is to easily configure multiple mission paths, and the parameters within each leg of the voyage. 
    \nEvery instance represents a configurable trip using the functions encapsulated in the class.
    '''

    # Initialize Class Variables for Trip Timings:
    MtoP = "1 days, 3 hours, 7 minutes, 9.64 seconds"       # Parking @ Mars to Phobos
    MtoD = "1 days, 11 hours, 48 minutes, 34.93 seconds"    # Parking @ Mars to Diemos
    PtoD = "8 hours, 52 minutes, 12.09 seconds"             # Phobos to Deimos
    # For transfer to swapped body (ex deimos to phobos), same time

    def __init__(self):

        # Change time and date of initialization here if needed:
        self.timeanddate = datetime.datetime(2040, 1, 1, 00, 00, 00) # 1-1-2040, 00:00:00    ## from daniil

        # Initialize Instance Variables:
        self.currenttime = 0
        self.MtoPsec = TextToSecs(MarsToMoonsTrip.MtoP)
        self.MtoDsec = TextToSecs(MarsToMoonsTrip.MtoD)
        self.PtoDsec = TextToSecs(MarsToMoonsTrip.PtoD)
        print(self.MtoPsec)
        print("\n\n\nNew Mission Beginning:\n")

    def MissionTime(self, time):
        '''
        \nInputs: time - in [s]
        \nArbitrarily assigned time, primary purpose is to represent the
        \ntime between maneuvers for completing research around a body.
        '''

        # Add time elapsed to total
        print("\nMission Idle Time:")
        print("Start at: " + str(self.timeanddate))
        self.currenttime += time
        self.timeanddate = self.timeanddate + datetime.timedelta(seconds = time)
        print("End at: " + str(self.timeanddate))
    
    def MarsToPhobos(self):
        '''
        \nTransfer time from Parking Orbit to Phobos.
        '''

        # Add transfer time to total
        print("\nParking to Phobos")
        print("From Parking at: " + str(self.timeanddate))
        self.currenttime += self.MtoPsec 
        self.timeanddate = self.timeanddate + datetime.timedelta(seconds = self.MtoPsec)
        print("Arriving at Phobos at: " + str(self.timeanddate))
    
    def MarsToDeimos(self):
        '''
        \nTransfer time from Parking Orbit to Deimos.
        '''

        # Add transfer time to total
        print("\nParking to Deimos")
        print("From Parking at: " + str(self.timeanddate))
        self.currenttime += self.MtoDsec
        self.timeanddate = self.timeanddate + datetime.timedelta(seconds = self.MtoDsec)
        print("Arriving at Deimos at: " + str(self.timeanddate))

    def PhobosToDeimos(self):
        '''
        \nTransfer time from Phobos to Deimos.
        '''

        # Add transfer time to total
        print("\nPhobos to Deimos:")
        print("From Phobos at: " + str(self.timeanddate))
        self.currenttime += self.PtoDsec
        self.timeanddate = self.timeanddate + datetime.timedelta(seconds = self.PtoDsec)
        print("Arriving at Deimos at: " + str(self.timeanddate))
    
    def DeimosToPhobos(self):
        '''
        \nTransfer time from Deimos to Phobos.
        '''

        # Add transfer time to total
        print("\nDeimos to Phobos:")
        print("From Deimos at: " + str(self.timeanddate))
        self.currenttime += self.PtoDsec
        self.timeanddate = self.timeanddate + datetime.timedelta(seconds = self.PtoDsec)
        print("Arriving at Phobos at: " + str(self.timeanddate))

    def PhobosToMars(self):
        '''
        \nTransfer time from Phobos to parking.
        '''

        # Add transfer time to total
        print("\nPhobos to Parking:")
        print("From Phobos at: " + str(self.timeanddate))
        self.currenttime += self.MtoPsec
        self.timeanddate = self.timeanddate + datetime.timedelta(seconds = self.MtoPsec)
        print("Arriving at Parking at: " + str(self.timeanddate))

    def DeimosToMars(self):
        '''
        \nTransfer time from from Deimos to parking.
        '''

        # Add transfer time to total
        print("\nDeimos to Parking:")
        print("From Deimos at: " + str(self.timeanddate))
        self.currenttime += self.MtoDsec
        self.timeanddate = self.timeanddate + datetime.timedelta(seconds = self.MtoDsec)
        print("Arriving at Parking at: " + str(self.timeanddate))
    
    def FinishTrip(self):
        '''
        \nDeclare to finish the trip.
        \nThis will show the end date and time elapsed for the mission.
        '''

        # Show results from trip
        print("\n\nTrip Finished!\n")
        print("Total Time Elapsed:")
        print("End Date:\n"+str(self.timeanddate))
        print("\nSeconds Elapsed: " + str(self.currenttime) + " [sec]")
        SecsToText(self.currenttime)
        print("End of Mission.\n\n")
        

if __name__ == "__main__":
    '''
    How to use MarsToMoonsTrip class:

    syntax:
    instance_name = MarsToMoons()        ... Creates an instance of MarsToMoons called instance_name
    instance_name.function()             ... Executes whatever function used to manipulate the time elapsed
    ... when finished ... 
    instance_name.FinishTrip()           ... Finishes the trip and displays the results

    Usable Functions for MarsToMoonsTrip class:
    - MissionTime(time)
        Adds and displays arbitrary time addition to timespan, meant to represent the idle wait time before transfer from a body
    - MarsToPhobos()
        Adds and displays time elapsed during transfer from Parking to Phobos to instance's total time count
    - MarsToDeimos()
        Adds and displays time elapsed during transfer from Parking to Deimos to instance's total time count
    - PhobosToDeimos()
        Adds and displays time elapsed during transfer from Phobos to Deimos to instance's total time count
    - DeimosToPhobos()
        Adds and displays time elapsed during transfer from Deimos to Phobos to instance's total time count
    - PhobosToMars()
        Adds and displays time elapsed during transfer from Phobos to Parking to instance's total time count
    - DeimosToMars()
        Adds and displays time elapsed during transfer from Deimos to Parking to instance's total time count
    - FinishTrip()
        Display's result for instance's time elapsed after mission has concluded
    '''

    # Wait times at each destination
    PWaitTime = "1 days, 0 hours, 0 minutes, 0 seconds"
    DWaitTime = "1 days, 0 hours, 0 minutes, 0 seconds"
    MWaitTime = "1 days, 0 hours, 0 minutes, 0 seconds"

    pwaitsec = TextToSecs(PWaitTime)
    dwaitsec = TextToSecs(DWaitTime)
    mwaitsec = TextToSecs(MWaitTime)

    Example_One = MarsToMoonsTrip()            # Create an instance of MarsTrip

    Example_One.MarsToPhobos()          # Go to Phobos from Parking Orbit
    Example_One.MissionTime(pwaitsec)   # Do research around Phobos
    Example_One.PhobosToDeimos()        # Go to Deimos from Phobos
    Example_One.MissionTime(dwaitsec)   # Do research around Deimos
    Example_One.DeimosToMars()          # Go to Parking Orbit from Deimos
    Example_One.MissionTime(mwaitsec)   # Do research around Mars
    Example_One.FinishTrip()            # Finish your trip

    Example_Two = MarsToMoonsTrip()            # Create an instance of MarsTrip

    Example_Two.MarsToDeimos()          # Go to Phobos from Parking Orbit
    Example_Two.MissionTime(pwaitsec)   # Do research around Phobos
    Example_Two.DeimosToPhobos()        # Go to Deimos from Phobos
    Example_Two.MissionTime(dwaitsec)   # Do research around Deimos
    Example_Two.PhobosToMars()          # Go to Parking Orbit from Deimos
    Example_Two.MissionTime(mwaitsec)   # Do research around Mars
    Example_Two.FinishTrip()            # Finish your trip

    print("\n\n\n\n\n\n\n ans:\n")
    print(TextToSecs("8 hours, 52 minutes, 12.09 seconds"))
    print(TextToSecs("1 days, 11 hours, 48 minutes, 34.93 seconds"))
    print(TextToSecs("1 days, 3 hours, 7 minutes, 9.64 seconds"))