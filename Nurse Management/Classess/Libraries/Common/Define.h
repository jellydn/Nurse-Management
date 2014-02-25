//
//  Define.h
//  FXStencil
//
//  Created by Le Phuong Tien on 1/22/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#ifndef NurseManagement_Define_h
#define NurseManagement_Define_h

#define APP_NAME @"Nurse Management"

#define START_TIME  10
#define END_TIME    20
#define HOUR_KEY    @"hour"
#define MINUTE_KEY  @"minute"

// entity names
#define ENTITY_SHIFT            @"CDShift"
#define ENTITY_SHIFT_ALERT      @"CDShiftAlert"

//NotifiCation
#define DID_ADD_SCHEDULE    @"DID_ADD_SCHEDULE"

//More App
#define URL_WS_OTHER_APP    @"http://site.dashapps.info/api/?appid=AP001&offset=%d&limit=%d"
#define URL_WS_RANKING         @"https://www.google.com"

// time formats

#define TIME_FORMAT_DMY_HYPHEN      @"dd-MM-yyyy"
//#define TIME_FORMAT_HM_COLONS       @"HH:mm"
#define TIME_FORMAT_FULL            @"dd-MM-yyyy HH:mm"


// Google Analytics
#define GA_HOMEVC                   @"Calendar screen"

#define GA_RANKINGVC                @"Ranking screen"
#define GA_MOREVC                   @"More screen"




#endif
