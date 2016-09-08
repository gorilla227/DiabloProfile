# DiabloProfile
Find Diablo3 hero profile from Blizzard and save to local device.

[iTunes Link](https://itunes.apple.com/us/app/dprofile-mobile-profile-for/id1150983228?l=zh&ls=1&mt=8)
## API
https://dev.battle.net/
- Career Profile - `GET /D3/PROFILE/:BATTLETAG/`
- Hero Profile - `GET /D3/PROFILE/:BATTLETAG/HERO/:ID`
- Get Item Data - `GET /D3/DATA/ITEM/:DATA`

## Example
1. Choose Server and Locale
2. Enter the [BattleTag](http://us.battle.net/en/battletag/)
3. Select Hero in list
4. Click **Bookmark** button on top right to add the hero to local list

### Test BattleTag
 - US: Pirlo#1588
 - CN: A11#51842

## KnownIssue
- Error message is not localized
