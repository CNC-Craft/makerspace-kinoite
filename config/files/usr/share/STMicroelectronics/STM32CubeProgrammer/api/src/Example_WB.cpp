/** 
* \file Example1.cpp
* This example allows to execute some operations to the internal STM32 Flash memory. \n
* 1.	Detect connected ST-LINK and display them. \n
* 2.	Loop on each ST-LINK probes and execute the following operations: \n
* 			-	Mass erase.
* 			-	Single word edition (-w32).
* 			-	Read 64 bytes from 0x08000000.
* 			-	Sector erase.
* 			-	Read 64 bytes from 0x08000000 .
*			-	System Reset. \n
*.
*Go to the source code : \ref STLINK_Example1 
* \example STLINK_Example1
* This example allows to execute some operations to the internal STM32 Flash memory. \n
* 1.	Detect connected ST-LINK and display them. \n
* 2.	Loop on each St-LINK probes and execute the following operations: \n
* 			-	Mass erase.
* 			-	Single word edition (-w32).
* 			-	Read 64 bytes from 0x08000000.
* 			-	Sector erase.
* 			-	Read 64 bytes from 0x08000000 .			
* 3.Perform WB related manips:
*           -FUS Start
*           -Firmware Upgrade
*           -Firmware Delete\n
  4.System Reset.
* \code{.cpp}
**/

#include <stdio.h>
#include <Example_WB.h>
#include <DisplayManager.h>
#include <CubeProgrammer_API.h>

int Example_WB(void) {

    logMessage(Title, "\n+++ Example STM32WB +++\n\n");

    debugConnectParameters *stLinkList;
    debugConnectParameters debugParameters;
    generalInf* genInfo;

    int getStlinkListNb = getStLinkList(&stLinkList, 0);

    if (getStlinkListNb == 0)
    {
        logMessage(Error, "No STLINK available\n");
        return 0;
    }
    else {
        logMessage(Title, "\n-------- Connected ST-LINK Probes List --------");
        for (int i = 0; i < getStlinkListNb; i++)
        {
            logMessage(Normal, "\nST-LINK Probe %d :\n", i);
            logMessage(Info, "   ST-LINK SN   : %s \n", stLinkList[i].serialNumber);
            logMessage(Info, "   ST-LINK FW   : %s \n", stLinkList[i].firmwareVersion);
        }
        logMessage(Title, "-----------------------------------------------\n\n");
    }

    for (int index = 0; index < getStlinkListNb; index++) {

        logMessage(Title, "\n--------------------- ");
        logMessage(Title, "\n ST-LINK Probe : %d ", index);
        logMessage(Title, "\n--------------------- \n\n");

        debugParameters = stLinkList[index];
        debugParameters.connectionMode = UNDER_RESET_MODE;
        debugParameters.shared = 0;

        /* Target connect */
        int connectStlinkFlag = connectStLink(debugParameters);
        if (connectStlinkFlag != 0) {
            logMessage(Error, "Establishing connection with the device failed\n");
            disconnect();
            continue;
        }
        else {
            logMessage(GreenInfo, "\n--- Device %d Connected --- \n",index);
        }

        /* Display device informations */
        genInfo = getDeviceGeneralInf();
        logMessage(Normal, "\nDevice name : %s ", genInfo->name);
        logMessage(Normal, "\nDevice type : %s ", genInfo->type);
        logMessage(Normal, "\nDevice CPU  : %s \n", genInfo->cpu);

        /* Apply mass Erase */
        int massEraseFlag = massErase();
        if (massEraseFlag != 0)
        {
            disconnect();
            continue;
        }

        /* Single word edition */
        int size = 4;
        int startAddress = 0x08000000;
        char data[8] = { (char)0xAA, (char)0xAA, (char)0xBB, (char)0xBB, (char)0xCC, (char)0xCC, (char)0xDD, (char)0xDD };
        int writeMemoryFlag = writeMemory(startAddress, data, size);
        if (writeMemoryFlag != 0)
        {
            disconnect();
            continue;
        }

        /* Reading 64 bytes from 0x08000000 */
        unsigned char* dataStruct = 0;
        size = 64;

        int readMemoryFlag = readMemory(startAddress, &dataStruct, size);
        if (readMemoryFlag != 0)
        {
            disconnect();
            continue;
        }

        logMessage(Normal, "\nReading 32-bit memory content\n");
        logMessage(Normal, "  Size          : %d Bytes\n", size);
        logMessage(Normal, "  Address:      : 0x%08X\n", startAddress);

        int i = 0, col=0;

        while ((i<size))
        {
            col = 0;
            logMessage(Normal, "\n0x%08X :", startAddress + i);
            while ((col<4) && (i<size))
            {
                logMessage(Info, " %08X ", *(unsigned int *)(dataStruct + i));
                col++;
                i += 4;
            }

        }
        logMessage(Normal, "\n");

        /* Sector Erase */
        unsigned int sectors[4] = { 0, 1, 2, 3 };  // we suppose that we have 4 sectors
        int sectorEraseFlag = sectorErase(sectors, 1); // we will erase just the first sector
        if (sectorEraseFlag != 0)
        {
            disconnect();
            continue;
        }

        /* Reading 64 bytes from 0x08000000 */
        i = 0, col = 0;
        size = 64;
        dataStruct = 0;

        readMemoryFlag = readMemory(startAddress, &dataStruct, size);
        if (readMemoryFlag != 0)
        {
            disconnect();
            continue;
        }

        logMessage(Normal, "\nReading 32-bit memory content\n");
        logMessage(Normal, "  Size          : %d Bytes\n", size);
        logMessage(Normal, "  Address:      : 0x%08X\n", startAddress);

        while ((i<size))
        {
            col = 0;
            logMessage(Normal, "\n0x%08X :",  startAddress + i);
            while ((col<4) && (i<size))
            {
                logMessage(Info, " %08X ", *(unsigned int *)(dataStruct + i));
                col++;
                i += 4;
            }
        }
        logMessage(Normal, "\n");

        /* instanciate option bytes */
        peripheral_C* ob = initOptionBytesInterface();
        if (ob == 0)
        {
            disconnect();
            return 0;
        }

        /* Display option bytes */
        for (unsigned int i = 0; i < ob->banksNbr; i++)
		{
			logMessage(Normal, "OPTION BYTES BANK: %d\n", i);
			for (unsigned int j = 0; j < ob->banks[i]->categoriesNbr; j++)
			{
				logMessage(Title, "\t%s\n", ob->banks[i]->categories[j]);
				for (unsigned int k = 0; k < ob->banks[i]->categories[j]->bitsNbr; k++)
				{
					if (ob->banks[i]->categories[j]->bits[k]->access == 0 || ob->banks[i]->categories[j]->bits[k]->access == 2) {
						logMessage(Normal, "\t\t%s", ob->banks[i]->categories[j]->bits[k]->name);
						logMessage(Info, ": 0x%x\n", ob->banks[i]->categories[j]->bits[k]->bitValue);
					}
				}
			}
		}

        bool retValstartFus = startFus();
        if (retValstartFus == false)
        {
            logMessage(Error, "\nFUS failed to be started\n");
            return(1);
        }

        /*Perform Firmware upgrade */
        bool retValueFusUp = firmwareUpgrade(L"../test file/stm32wb5x_BLE_LLD_fw.bin",0x08065000, FIRST_INSTALL_NOT_ACTIVE, START_STACK_NOT_ACTIVE, VERIFY_FILE_DOWLOAD_FILE);
        if (retValueFusUp == false)
        {
            logMessage(Error, "\nFUS Upgrade failed\n");
            return(1);
        }
        /* Start the FUS */
        retValstartFus = startFus(); // FIXME PLS : minuscule
        if (retValstartFus == false)
        {
            logMessage(Error, "\nFUS failed to be started\n");
            return(1);
        }
        /*Perform Delete Firmware*/

        bool retValueFirmDelete = firmwareDelete();
        if (retValueFirmDelete == false)
        {
            logMessage(Error, "FW Delete failed\n");
        }

        /* Apply a System Reset */
        int resetStatus = reset(SOFTWARE_RESET); // FIXME replace flag par status 
        if (resetStatus != 0)
        {
            logMessage(Error, "\nUnable to reset MCU!\n");
            disconnect();
            continue;
        }
        else
            logMessage(GreenInfo, "\nSystem Reset is performed\n");

        /* Process successfully Done */
        disconnect();
    }


    deleteInterfaceList();
    return 1;

}

/** \endcode **/
