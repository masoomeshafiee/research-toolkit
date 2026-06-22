import sys
from ij import IJ
from ij import WindowManager
from fiji.plugin.trackmate import TrackMate
from fiji.plugin.trackmate import Model
from fiji.plugin.trackmate import SelectionModel
from fiji.plugin.trackmate import Settings
from fiji.plugin.trackmate import Logger
from fiji.plugin.trackmate.detection import LogDetectorFactory
from fiji.plugin.trackmate.tracking.sparselap import SparseLAPTrackerFactory #trackmate developer change it from time to time, if you update find the current
from fiji.plugin.trackmate.gui.displaysettings import DisplaySettingsIO
from fiji.plugin.trackmate.visualization.hyperstack import HyperStackDisplayer
import fiji.plugin.trackmate.features.FeatureFilter as FeatureFilter
from fiji.plugin.trackmate.util import TMUtils
import csv
import os
import math
import time
import itertools as itto

# We have to do the following to avoid errors with UTF8 chars generated in 
# TrackMate that will mess with our Fiji Jython.
reload(sys)
sys.setdefaultencoding('utf-8')
 
 
# Get currently selected image
# imp = WindowManager.getCurrentImage()


'''
         ██████  ███    ██ ██   ██    ██     ███████ ██████  ██ ████████     ███    ███  █████  ██ ███    ██      ██     ██  
        ██    ██ ████   ██ ██    ██  ██      ██      ██   ██ ██    ██        ████  ████ ██   ██ ██ ████   ██     ██       ██ 
        ██    ██ ██ ██  ██ ██     ████       █████   ██   ██ ██    ██        ██ ████ ██ ███████ ██ ██ ██  ██     ██       ██ 
        ██    ██ ██  ██ ██ ██      ██        ██      ██   ██ ██    ██        ██  ██  ██ ██   ██ ██ ██  ██ ██     ██       ██ 
         ██████  ██   ████ ███████ ██        ███████ ██████  ██    ██        ██      ██ ██   ██ ██ ██   ████      ██     ██  
                                                                                              
'''
#########################################################################################################################################################################################################################################################
#########################################################################################################################################################################################################################################################
#########################################################################################################################################################################################################################################################


def main():
    #Set to the directory where .tif images of singles cells are
    dir_tiff = "/Users/masoomeshafiee/Desktop/trackmate/streams/"
    for (root, dirs, files) in os.walk(dir_tiff):
        files = [ fi for fi in files if fi.endswith(".tif") ]
    save_analysis_dir = dir_tiff + '/' + 'Analysis' 
    os.mkdir(save_analysis_dir)
            #link_dist=3.0, gap_link_dist=5.0, split_dist=0.0, merg_dist=0.0, int_thresh=2.0, cost_q=0.0
    link_parameters =[3.0,      5.0,            0.0,           0.0,   240.0,      0.3, files, save_analysis_dir]
    link_parameters2 =[7.0,     8.0,           0.0,           0.0,   600.0,      0.0, files, save_analysis_dir]
    QSummary1=[]
    QSummary2=[]
    print(link_parameters[6])
    for z in range(len(link_parameters[6])):
    
        #default Tracking     (dir_tiff, link_parameters,z, Run=0, AutoQcoe=1.50, Radius=1.50, Max_Frame_Gap=2,   Quality=0,   number_threads=4, Bound=1):
        Details1 =   Tracking (dir_tiff, link_parameters,z,      1,       1.2,      1.50,               1,        600,              16,       1)
        Details2 =   Tracking (dir_tiff, link_parameters2,z,     1,       1.2,      1.50,               2,       400,              16,       0)
     
    #write _summary.csv 
        if not Details1 == None:
            QSummary1.append(Details1)
        if not Details2 == None:
            QSummary2.append(Details2)


    
    QSummary1.insert(0, ['Cell_ID', 'AutoQ_Used', '#Spots', 'Avg_intensity', '#Tracks', 'Longest_Track', 'Avg_Trk_Dur'])
    with open(link_parameters[7] + "/" + "_SummaryBound.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerows(QSummary1)

    #write _summary.csv 



    
    QSummary2.insert(0, ['Cell_ID', 'AutoQ_Used', '#Spots', 'Avg_intensity', '#Tracks', 'Longest_Track', 'Avg_Trk_Dur'])
    with open(link_parameters[7] + "/" + "_SummaryLifetime.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerows(QSummary2)


#########################################################################################################################################################################################################################################################
#########################################################################################################################################################################################################################################################
#########################################################################################################################################################################################################################################################


def Tracking(dir_tiff, link_parameters, z,  Run=0, AutoQcoe=1.50, Radius=1.50, Max_Frame_Gap=2, Quality=0, number_threads=4, Bound=1):
    """
    Args:
        dir_tiff:         Directory where .tif images of singles cells are
        link_parameters:   List, return of function start()
        Run:               Input 0 to calculate AutoQ and 1 to do the filtering steps
        AutoQcoe:         From 1-2, alters AutoQuality calculation more equals a higher Quality threshold
        Radius:            Average radius of spots in px
        Max_Frame_gap:   Number of frames which can be skipped for gap-closing
        Quality:           Used to override AutoQuality with a single quality value in Run=1
        number_threads   Number of threads (logical cores) in your computer
    Returns:
        creates two csv files for each tif file input, one with track information described in data_final and one with spot information described in spt_all_fin in Analysis folder
        returns a list with the following structure ['Cell_ID', 'AutoQ_Used', '#Spots', '#Tracks']
        
    """
    rQ=[]
    str_name_fil = dir_tiff + '/' + link_parameters[6][z]
    print(str_name_fil,'*****************************************************************************')
    imp = IJ.openImage(str_name_fil)
    #imp.show()
     
#########################################################################################################################################################################################################################################################
#########################################################################################################################################################################################################################################################
#########################################################################################################################################################################################################################################################

    #-------------------------
    # Instantiate model object
    #-------------------------
     
    model = Model()
     
    # Set logger
    model.setLogger(Logger.IJ_LOGGER)
     
    #------------------------
    # Prepare settings object
    #------------------------
     
    settings = Settings(imp)
    # Configure detector
    settings.detectorFactory = LogDetectorFactory()
    settings.detectorSettings = {
        'DO_SUBPIXEL_LOCALIZATION' : True,
        'RADIUS' : Radius,
        'TARGET_CHANNEL' : 1,
        'THRESHOLD' : link_parameters[4],
        'DO_MEDIAN_FILTERING' : True,
    }
    print(settings)
    # Configure tracker
    settings.trackerFactory = SparseLAPTrackerFactory()
    settings.trackerSettings = settings.trackerFactory.getDefaultSettings()
    settings.trackerSettings['LINKING_MAX_DISTANCE'] = link_parameters[0]
    settings.trackerSettings['GAP_CLOSING_MAX_DISTANCE'] = link_parameters[1]
    settings.trackerSettings['SPLITTING_MAX_DISTANCE'] = link_parameters[2]
    settings.trackerSettings['MERGING_MAX_DISTANCE'] = link_parameters[3]
    settings.trackerSettings['MAX_FRAME_GAP'] = Max_Frame_Gap
    settings.trackerSettings['ALLOW_TRACK_SPLITTING'] = False
    settings.trackerSettings['ALLOW_TRACK_MERGING'] = False
    settings.trackerSettings['LINKING_FEATURE_PENALTIES'] = {'QUALITY' : 0.3}
	    
    # Add the analyzers for some spot features.
    # Here we decide brutally to add all of them.
    settings.addAllAnalyzers()
     
    # We configure the initial filtering to discard spots 
    # with a quality lower than 1.
    settings.initialSpotFilterValue = 10.0
    
    # Configure spot filters - Classical filter on quality
    '''
    filter1 = FeatureFilter('MAX_INTENSITY_CH1', Quality, True)
    settings.addSpotFilter(filter1)
    '''
    # Configure track filters
    '''
    if Bound!=0:
    	filter2 = FeatureFilter('TRACK_STD_SPEED', 0.7, False)
    	settings.addTrackFilter(filter2)
    '''
    filter3 = FeatureFilter('TRACK_DURATION', 10000, False)#to remove dirt or high bound outliers
    settings.addTrackFilter(filter3)
    filter4 = FeatureFilter('TRACK_DURATION', 0, True)
    settings.addTrackFilter(filter4)
    
    print(str(settings))
     
    #----------------------
    # Instantiate trackmate
    #----------------------
     
    trackmate = TrackMate(model, settings)
     
    #------------
    # Execute all checks
    #------------
     
     
    ok = trackmate.checkInput()
    if not ok:
        print('sysErrorInput')
        return
    #if not ok:
        #sys.exit(str(trackmate.getErrorMessage()))
    
    ok = trackmate.process()
    if not ok:
        print('sysErrorProcess')
        return
        #sys.exit(str(trackmate.getErrorMessage()))
    
    spt_m = model.getSpots()
    tracks_found = model.getTrackModel().trackIDs(True)
    tot_spts = spt_m.getNSpots(True)
    print(model)
    print("Spot total: ", spt_m.getNSpots(True))
    print ("Tracks total: ",len(model.getTrackModel().trackIDs(True)))
    
    if not (tot_spts>0):
        print('No spots found')
        return
    if not tracks_found:
        print('No Tracks found')
        return
     
    #----------------
    # Display results
    #----------------
     
    model.getLogger().log('Found ' + str(model.getTrackModel().nTracks(True)) + ' tracks.')
     
    # A selection.
    sm = SelectionModel( model )
     
    # Read the default display settings.
    ds = DisplaySettingsIO.readUserDefault()
     
    # The viewer.
    if z==0:
    	displayer =  HyperStackDisplayer( model, sm, imp, ds ) 
    	displayer.render()
     
    # The feature model, that stores edge and track features.
    fm = model.getFeatureModel()
    
    Track_IDs = [None]*0
    mean_sp = [None]*0
    med_sp = [None]*0
    min_sp = [None]*0
    max_sp = [None]*0
    std_sp = [None]*0
    mean_q = [None]*0
    med_q_tr = [None]*0
    min_q_tr = [None]*0
    max_q_tr = [None]*0
    std_q_tr = [None]*0
    x_lc = [None]*0
    y_lc = [None]*0
    mn_int = [None]*0
    inten = [None]*0
    tr_dur = [None]*0
    tr_start = [None]*0
    tr_fin = [None]*0
    spt_tr = [None]*0
    spt_widt = [None]*0
    tr_charact = [None]*0
    x_tr = [None]*0
    y_tr = [None]*0
    spt_all_x = [None]*0
    spt_all_y = [None]*0
    tr_identifi = [None]*0
    tr_fram = [None]*0
    poolIDs=[]
    
    # Iterate over all the tracks that are visible.
    print(model)
    for id in model.getTrackModel().trackIDs(True):

     
        # Fetch the track feature from the feature model.
        v = fm.getTrackFeature(id, 'TRACK_MEAN_SPEED')
        med_v = fm.getTrackFeature(id, 'TRACK_MEDIAN_SPEED')
        min_v = fm.getTrackFeature(id, 'TRACK_MIN_SPEED')
        max_v = fm.getTrackFeature(id, 'TRACK_MAX_SPEED')
        std_v = fm.getTrackFeature(id, 'TRACK_STD_SPEED')
        q = fm.getTrackFeature(id, 'TRACK_MEAN_QUALITY')
        med_q = fm.getTrackFeature(id, 'TRACK_MEDIAN_QUALITY')
        min_q = fm.getTrackFeature(id, 'TRACK_MIN_QUALITY')
        max_q = fm.getTrackFeature(id, 'TRACK_MAX_QUALITY')
        std_q = fm.getTrackFeature(id, 'TRACK_STD_QUALITY')
        dura = fm.getTrackFeature(id, 'TRACK_DURATION')
        start_tr = fm.getTrackFeature(id, 'TRACK_START')
        fin_tr = fm.getTrackFeature(id, 'TRACK_STOP')
        spts = fm.getTrackFeature(id, 'NUMBER_SPOTS')
        tr_identif = fm.getTrackFeature(id,'TRACK_ID')
        identi = [int(id)]*int(spts)
        x_loc = fm.getTrackFeature(id, 'TRACK_X_LOCATION')
        y_loc = fm.getTrackFeature(id, 'TRACK_Y_LOCATION')
        poolIDs.append(id)
        #model.getLogger().log('')
        #model.getLogger().log('Track ' + str(id) + ': mean velocity = ' + str(v) + ' ' + model.getSpaceUnits() + '/' + model.getTimeUnits())
     
        # Get all the spots of the current track.
        track = model.getTrackModel().trackSpots(id)
        track_int = [None]*0
        track_x = [None]*0
        track_y = [None]*0
        track_coord = [None]*0
        inten2 = [None]*0
        track_shp = [None]*0
        fram = [None]*0
        qlist= [None]*0
        for spot in track:
            sid = spot.ID()
            # Fetch spot features directly from spot.
            x=spot.getFeature('POSITION_X')
            y=spot.getFeature('POSITION_Y')
            t=spot.getFeature('FRAME')
            q=spot.getFeature('QUALITY')
            snr=spot.getFeature('SNR_CH1')
            tot_int_spot=spot.getFeature('TOTAL_INTENSITY_CH1')
            wid=spot.getFeature('RADIUS')
            track_int.append(tot_int_spot)
            #inten2.append(mean_int_spot)
            track_x.append(x)
            track_y.append(y)
            fram.append(t)
            qlist.append(q)
            #track_coord.append(t, x, y)
            track_shp.append(wid)

            #print(x,y,t,q,snr,tot_int_spot,wid)
        Track_IDs.append(id)# = id
        mean_sp.append(v)
        med_q= qlist[int(round((len(qlist)/2)))]
        min_q= min(qlist)
        max_q= max(qlist)
        std_q = math.sqrt(sum(pow(x-sum(qlist)/len(qlist),2) for x in qlist) / len(qlist))  # standard deviation
        med_sp.append(med_v)# =
        min_sp.append(min_v) #= min_v
        max_sp.append(max_v)
        std_sp.append(std_v)#= max_v
        mean_q.append(q)
        med_q_tr.append(med_q)#= q
        min_q_tr.append(min_q)
        max_q_tr.append(max_q)
        std_q_tr.append(std_q)#= min_q
        x_loc = sum(track_x)/len(track_x)
        y_loc = sum(track_y)/len(track_y)
        x_lc.append(x_loc) #= x_loc
        #print(x_loc,y_loc,track_int)
        y_lc.append(y_loc) #= y_loc
        mean_track_int = sum(track_int)/len(track_int)
        mn_int.append(mean_track_int) #= mean_int
        inten = inten + track_int
        tr_dur.append(dura)
        tr_start.append(start_tr)
        tr_fin.append(fin_tr)
        spt_tr.append(spts)
        spt_widt.append(sum(track_shp)/len(track_shp))
        tr_fram = tr_fram + fram
        x_tr = x_tr + track_x
        y_tr = y_tr + track_y
        tr_identifi = tr_identifi + identi
    qTracks = TMUtils.otsuThreshold(mean_q)
    qSpots = TMUtils.otsuThreshold(x_tr)        
    spt_all_fin = [tr_identifi, tr_fram, x_tr, y_tr, inten]
    spt_all_fin_2 = [[row[i] for row in spt_all_fin]
                             for i in range(len(spt_all_fin[0]))]
                             

    data_final = [Track_IDs, spt_tr, spt_widt, mean_sp, max_sp, min_sp, med_sp, std_sp, mean_q, max_q_tr, min_q_tr, med_q_tr, std_q_tr, tr_dur, tr_start, tr_fin, x_lc, y_lc]
    data_final_2 = [[row[i] for row in data_final]
                             for i in range(len(data_final[0]))]
                             
    TrackL= [x for x in data_final[13] if x >=0]
    if ((sum(TrackL)+0.0000001)/(len(TrackL)+0.0000001)) <0:
            return
    
    if Run!=0:                      
        if Bound!=0:
            dir_name_save = link_parameters[7] + '/' + link_parameters[6][z] + '_' + 'tracksBound'
            dir_name_save_inten = link_parameters[7] + '/' + link_parameters[6][z] + '_' + 'spotsBound'
            str_save = dir_name_save + '.csv'
            str_save_inten = dir_name_save_inten + '.csv'
    
             
        else:
            dir_name_save = link_parameters[7] + '/' + link_parameters[6][z] + '_' + 'tracksLifetime'
            dir_name_save_inten = link_parameters[7] + '/' + link_parameters[6][z] + '_' + 'spotsLifetime'
            str_save = dir_name_save + '.csv'
            str_save_inten = dir_name_save_inten + '.csv'
    
        with open(str_save, "w") as f:
            writer = csv.writer(f,delimiter=',')
            writer.writerows(data_final_2)
        with open(str_save_inten, "w") as f:
            writer = csv.writer(f,delimiter=',')
            writer.writerows(spt_all_fin_2)
        IJ.log('Success')
        if z!=0:
        	imp.close()
        	imp.flush()
        return [link_parameters[6][z],Quality,len(spt_all_fin_2), sum(spt_all_fin[4])/len(spt_all_fin[4]),len(TrackL), max(data_final[13]), (sum(TrackL)+0.0000001)/((len(TrackL)+0.0000001))]
        
        
    else: # to find parameters before calculation step
        if qTracks*AutoQcoe >= 15:
            rQ = 15
            return rQ
        else:
            rQ = qTracks*AutoQcoe
            return rQ
if True:
    start_time = time.time()
    main()
    print("--- %s seconds ---" % (time.time() - start_time))