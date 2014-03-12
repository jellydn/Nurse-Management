//
//  Define.h
//  FXStencil
//
//  Created by Le Phuong Tien on 1/22/14.
//  Copyright (c) 2014 Le Phuong Tien. All rights reserved.
//

#ifndef NurseManagement_Define_h
#define NurseManagement_Define_h

//#define APP_NAME @"Nurse Management"
#define APP_NAME @""

#define START_TIME      10
#define END_TIME        20
#define ANOTHER_TIME    30
#define HOUR_KEY    @"hour"
#define MINUTE_KEY  @"minute"

// entity names
#define ENTITY_SHIFT            @"CDShift"
#define ENTITY_SHIFT_ALERT      @"CDShiftAlert"

//NotifiCation
#define DID_ADD_SCHEDULE    @"DID_ADD_SCHEDULE"

//More App
//#define URL_WS_OTHER_APP      @"http://site.dashapps.info/api/?appid=AP001&offset=%d&limit=%d"
#define URL_WS_OTHER_APP        @"http://ad.smaad.jp/moreApps/dataJSON/?zoneId=61517948&type=ios&start=%d&limit=%d"
#define URL_WS_RANKING         @"http://app.grillshop.info/ranking/ranking.html"

#define URL_WEB_AD_BANER                @"http://www.google.com/"
#define URL_WEB_AD_OPENT_SAFARI         @"http://www.google.com/"

// time formats
#define TIME_FORMAT_DMY_HYPHEN      @"dd-MM-yyyy"
#define TIME_FORMAT_FULL            @"dd-MM-yyyy HH:mm"

//index first of Calendar
#define FIRST_OF_CALENDAR           @"FIRST_OF_CALENDAR"
#define HIDE_MEMBER                 @"HIDE_MEMBER"
#define OPEN_AD_VIEW                @"OPEN_AD_VIEW"

#define TEXT_ALL_DAY            @"終日"

//edit/add shift category
#define TEXT_VALIDATION_NAME_SHIFT_CATEGORY @"Please enter up to 2 characters."

// Google Analytics
#define GA_HOMEVC                   @"Calendar screen"

#define GA_RANKINGVC                @"Ranking screen"
#define GA_MOREVC                   @"More screen"

#define GA_ADDSHIFTVC               @"Add Shift screen"
#define GA_LISTMEMBERSVC            @"List Members screen"
#define GA_ADDMEMBERVC              @"Add Member screen"

#endif
