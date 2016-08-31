//
//  BlizzardAPI_Constants.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/14/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation

extension BlizzardAPI {
    static let configurations = AppDelegate.configurations()
    
    struct ParameterKeys {
        static let Locale = "locale"
        static let API_Key = "apikey"
    }
    
    struct ResponseKeys {
        static let ErrorCode = "code"
        static let ErrorReason = "reason"
        static let BattleTag = "battleTag"
        static let Heroes = "heroes"
        static let Class = "class"
        static let Dead = "dead"
        static let Gender = "gender"
        static let ID = "id"
        static let Hardcore = "hardcore"
        static let Level = "level"
        static let Name = "name"
        static let ParagonLevel = "paragonLevel"
        static let Seasonal = "seasonal"
        static let LastUpdated = "last-updated"
        
        static let SeasonCreated = "seasonCreated"
        static let Skills = "skills"
        static let ActiveSkill = "active"
        static let PassiveSkill = "passive"
        static let Skill = "skill"
        static let Rune = "rune"
        static let Stats = "stats"
        static let Items = "items"
        
        struct SkillRuneKeys {
            static let Slug = "slug"
            static let Name = "name"
            static let IconKey = "icon"
            static let CategorySlug = "categorySlug"
            static let FullDescription = "description"
            static let SimpleDescription = "simpleDescription"
            static let Flavor = "flavor"
            static let RuneType = "type"
        }
        
        struct StatsKeys {
            static let Life = "life"
            static let Damage = "damage"
            static let Toughness = "toughness"
            static let Healing = "healing"
//            static let AttackSpeed = "attackSpeed"
//            static let Armor = "armor"
            static let Strength = "strength"
            static let Dexterity = "dexterity"
            static let Vitality = "vitality"
            static let Intelligence = "intelligence"
//            static let PhysicalResist = "physicalResist"
//            static let FireResist = "fireResist"
//            static let ColdResist = "coldResist"
//            static let LightningResist = "lightningResist"
//            static let PoisonResist = "poisonResist"
//            static let ArcaneResist = "arcaneResist"
//            static let CritDamage = "critDamage"
//            static let BlockChance = "blockChance"
//            static let BlockAmountMin = "blockAmountMin"
//            static let BlockAmountMax = "blockAmountMax"
//            static let DamageIncrease = "damageIncrease"
//            static let CritChance = "critChance"
//            static let DamageReduction = "damageReduction"
//            static let Thorns = "thorns"
//            static let LifeSteal = "lifeSteal"
//            static let LiferPerKill = "lifePerKill"
//            static let GoldFind = "goldFind"
//            static let MagicFind = "magicFind"
//            static let LifeOnHit = "lifeOnHit"
            static let PrimaryResource = "primaryResource"
            static let SecondaryResource = "secondaryResource"
        }
        
        struct ItemKeys {
            // BasicItemKeys
            static let ID = "id"
            static let Name = "name"
            static let Icon = "icon"
            static let DisplayColor = "displayColor"
            static let TooltipParams = "tooltipParams"
            static let SetItemsEquipped = "setItemsEquipped"
            
            // DetailItemKeys
            static let RequiredLevel = "requiredLevel"
            static let ItemLevel = "itemLevel"
            static let AccountBound = "accountBound"
            static let FlavorText = "flavorText"
            static let TypeName = "typeName"
            static let Type = "type"
            static let TypeID = "id"
            static let TypeTwoHanded = "twoHanded"
            static let DamageRange = "damageRange"
            static let Attributes = "attributes"
            static let Gems = "gems"
            static let Armor = "armor"
            static let Min = "min"
            static let Max = "max"
            static let ItemSet = "set"
            static let DPS = "dps"
            static let AttacksPerSecond = "attacksPerSecond"
            static let AttacksPerSecondText = "attacksPerSecondText"
            
            struct AttributeKeys {
                static let Text = "text"
                static let Color = "color"
                static let AffixType = "affixType"
            }
            
            struct GemKeys {
                static let Item = "item"
                static let IsGem = "isGem"
                static let IsJewel = "isJewel"
                static let Attributes = "attributes"
                static let JewelRank = "jewelRank"
                static let JewelSecondaryEffectUnlockRank = "jewelSecondaryEffectUnlockRank"
            }
            
            struct SetKeys {
                static let Name = "name"
                static let SetItems = "items"
                static let Slug = "slug"
                static let Bonus = "ranks"
                static let BonusRequired = "required"
                static let BonusAttributes = "attributes"
            }
        }
    }
    
    struct Separator {
        static let BattleTag_OriginalSeparator = "#"
        static let BattleTag_APISepartor = "-"
    }
    
    struct Token {
        static let BattleTag_Token = "<battletag>"
        static let HeroID_Token = "<id>"
        static let ItemTooltipParams = "<itemTooltipParams>"
    }
    
    struct SkillIconURLComponents {
        static let Head = "http://media.blizzard.com/d3/icons/skills/42/"
        static let Tail = ".png"
    }
    
    struct ItemIconURLComponents {
        static let Head = "http://media.blizzard.com/d3/icons/items/"
        static let Tail = ".png"
    }
    
    struct PathKeys {
        static let CareerProfile = "CareerProfile"
        static let HeroProfile = "HeroProfile"
        static let ItemData = "ItemData"
    }
    
    struct BasicKeys {
        static let Scheme = "Scheme"
        static let API_Key = "API_Key"
        static let API_Secret = "API_Secret"
        static let Host = "Host"
        static let Path = "Path"
        static let RegionAndLocale = "RegionsLocales"
        static let Region = "Region"
        static let Locales = "Locales"
    }
    
    struct HttpMethod {
        static let Get = "GET"
    }
}