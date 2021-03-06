//
//  BlizzardAPI_DataCoding.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/16/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation

extension BlizzardAPI {
    class func decodeCareerProfile(deserializedData: AnyObject) -> [[String: AnyObject]]? {
        if let careerProfile = deserializedData as? [String: AnyObject], let heroes = careerProfile[ResponseKeys.Heroes] as? [[String: AnyObject]] {
            var result = [[String: AnyObject]]()
            for hero in heroes {
                var heroDict = [String: AnyObject]()
                
                if let id = hero[ResponseKeys.ID] as? NSNumber {
                    heroDict[Hero.Keys.ID] = id
                }
                if let heroClass = hero[ResponseKeys.Class] as? String {
                    heroDict[Hero.Keys.HeroClass] = heroClass
                }
                if let dead = hero[ResponseKeys.Dead] as? NSNumber {
                    heroDict[Hero.Keys.Dead] = dead.boolValue
                }
                if let gender = hero[ResponseKeys.Gender] as? NSNumber {
                    heroDict[Hero.Keys.Gender] = gender.boolValue
                }
                if let hardcore = hero[ResponseKeys.Hardcore] as? NSNumber {
                    heroDict[Hero.Keys.Hardcore] = hardcore.boolValue
                }
                if let level = hero[ResponseKeys.Level] as? NSNumber {
                    heroDict[Hero.Keys.Level] = level
                }
                if let name = hero[ResponseKeys.Name] as? String {
                    heroDict[Hero.Keys.Name] = name
                }
                if let paragonLevel = hero[ResponseKeys.ParagonLevel] as? NSNumber {
                    heroDict[Hero.Keys.ParagonLevel] = paragonLevel
                }
                if let seasonal = hero[ResponseKeys.Seasonal] as? NSNumber {
                    heroDict[Hero.Keys.Seasonal] = seasonal.boolValue
                }
                if let lastUpdated = hero[ResponseKeys.LastUpdated] as? NSNumber {
                    heroDict[Hero.Keys.LastUpdated] = lastUpdated
                }
                
                result.append(heroDict)
            }
            return result
        }
        return nil
    }
    
    class func decodeHeroProfile(deserializeData: AnyObject) -> [String: AnyObject]? {
        if let heroProfile = deserializeData as? [String: AnyObject] {
            var result = [String: AnyObject]()
            if let id = heroProfile[ResponseKeys.ID] as? NSNumber {
                result[Hero.Keys.ID] = id
            }
            if let name = heroProfile[ResponseKeys.Name] as? String {
                result[Hero.Keys.Name] = name
            }
            if let heroClass = heroProfile[ResponseKeys.Class] as? String {
                result[Hero.Keys.HeroClass] = heroClass
            }
            if let dead = heroProfile[ResponseKeys.Dead] as? NSNumber {
                result[Hero.Keys.Dead] = dead.boolValue
            }
            if let gender = heroProfile[ResponseKeys.Gender] as? NSNumber {
                result[Hero.Keys.Gender] = gender.boolValue
            }
            if let hardcore = heroProfile[ResponseKeys.Hardcore] as? NSNumber {
                result[Hero.Keys.Hardcore] = hardcore.boolValue
            }
            if let level = heroProfile[ResponseKeys.Level] as? NSNumber {
                result[Hero.Keys.Level] = level
            }
            if let paragonLevel = heroProfile[ResponseKeys.ParagonLevel] as? NSNumber {
                result[Hero.Keys.ParagonLevel] = paragonLevel
            }
            if let seasonal = heroProfile[ResponseKeys.Seasonal] as? NSNumber {
                result[Hero.Keys.Seasonal] = seasonal.boolValue
            }
            if let lastUpdated = heroProfile[ResponseKeys.LastUpdated] as? NSNumber {
                result[Hero.Keys.LastUpdated] = lastUpdated
            }
            if let seasonCreated = heroProfile[ResponseKeys.SeasonCreated] as? NSNumber {
                result[Hero.Keys.SeasonCreated] = seasonCreated
            }
            // Skills
            if let skills = heroProfile[ResponseKeys.Skills] as? [String: AnyObject] {
                // Active Skills
                if let activeSkills = skills[ResponseKeys.ActiveSkill] as? [[String: AnyObject]] {
                    var aSkills = [[String: AnyObject]]()
                    for aSkill in activeSkills {
                        if let baseSkill = aSkill[ResponseKeys.Skill] as? [String: AnyObject] {
                            var skillDict = [String: AnyObject]()
                            if let slug = baseSkill[ResponseKeys.SkillRuneKeys.Slug] as? String {
                                skillDict[Spell.Keys.Slug] = slug
                            }
                            if let name = baseSkill[ResponseKeys.SkillRuneKeys.Name] as? String {
                                skillDict[Spell.Keys.Name] = name
                            }
                            if let iconKey = baseSkill[ResponseKeys.SkillRuneKeys.IconKey] as? String {
                                skillDict[Skill.Keys.IconURL] = iconKey
                            }
                            if let categorySlug = baseSkill[ResponseKeys.SkillRuneKeys.CategorySlug] as? String {
                                skillDict[Skill.Keys.CategorySlug] = categorySlug
                            }
                            if let fullDescription = baseSkill[ResponseKeys.SkillRuneKeys.FullDescription] as? String {
                                skillDict[Spell.Keys.FullDescription] = fullDescription
                            }
                            if let simpleDescription = baseSkill[ResponseKeys.SkillRuneKeys.SimpleDescription] as? String {
                                skillDict[Spell.Keys.SimpleDescription] = simpleDescription
                            }
                            
                            //Rune
                            if let rune = aSkill[ResponseKeys.Rune] as? [String: AnyObject] {
                                var runeDict = [String: AnyObject]()
                                if let slug = rune[ResponseKeys.SkillRuneKeys.Slug] as? String {
                                    runeDict[Spell.Keys.Slug] = slug
                                }
                                if let name = rune[ResponseKeys.SkillRuneKeys.Name] as? String {
                                    runeDict[Spell.Keys.Name] = name
                                }
                                if let fullDescription = rune[ResponseKeys.SkillRuneKeys.FullDescription] as? String {
                                    runeDict[Spell.Keys.FullDescription] = fullDescription
                                }
                                if let simpleDescription = rune[ResponseKeys.SkillRuneKeys.SimpleDescription] as? String {
                                    runeDict[Spell.Keys.SimpleDescription] = simpleDescription
                                }
                                if let runeType = rune[ResponseKeys.SkillRuneKeys.RuneType] as? String {
                                    runeDict[Rune.Keys.RuneType] = runeType
                                }
                                skillDict[Skill.Keys.Rune] = runeDict
                            }
                            aSkills.append(skillDict)
                        }
                    }
                    result[Hero.Keys.ActiveSkills] = aSkills
                }
                
                // Passive Skills
                if let passiveSkills = skills[ResponseKeys.PassiveSkill] as? [[String: AnyObject]] {
                    var pSkills = [[String: AnyObject]]()
                    for pSkill in passiveSkills {
                        if let baseSkill = pSkill[ResponseKeys.Skill] as? [String: AnyObject] {
                            var skillDict = [String: AnyObject]()
                            if let slug = baseSkill[ResponseKeys.SkillRuneKeys.Slug] as? String {
                                skillDict[Spell.Keys.Slug] = slug
                            }
                            if let name = baseSkill[ResponseKeys.SkillRuneKeys.Name] as? String {
                                skillDict[Spell.Keys.Name] = name
                            }
                            if let iconKey = baseSkill[ResponseKeys.SkillRuneKeys.IconKey] as? String {
                                skillDict[Skill.Keys.IconURL] = iconKey
                            }
                            if let categorySlug = baseSkill[ResponseKeys.SkillRuneKeys.CategorySlug] as? String {
                                skillDict[Skill.Keys.CategorySlug] = categorySlug
                            }
                            if let fullDescription = baseSkill[ResponseKeys.SkillRuneKeys.FullDescription] as? String {
                                skillDict[Spell.Keys.FullDescription] = fullDescription
                            }
                            if let simpleDescription = baseSkill[ResponseKeys.SkillRuneKeys.SimpleDescription] as? String {
                                skillDict[Spell.Keys.SimpleDescription] = simpleDescription
                            }
                            if let flavor = baseSkill[ResponseKeys.SkillRuneKeys.Flavor] as? String {
                                skillDict[Skill.Keys.Flavor] = flavor
                            }
                            pSkills.append(skillDict)
                        }
                    }
                    result[Hero.Keys.PassiveSkills] = pSkills
                }
            }
            
            // Stats
            if let stats = heroProfile[ResponseKeys.Stats] as? [String: AnyObject] {
                var statsDict = [String: AnyObject]()
                if let life = stats[ResponseKeys.StatsKeys.Life] as? NSNumber {
                    statsDict[Stats.Keys.Life] = life
                }
                if let damage = stats[ResponseKeys.StatsKeys.Damage] as? NSNumber {
                    statsDict[Stats.Keys.Damage] = damage
                }
                if let toughness = stats[ResponseKeys.StatsKeys.Toughness] as? NSNumber {
                    statsDict[Stats.Keys.Toughness] = toughness
                }
                if let healing = stats[ResponseKeys.StatsKeys.Healing] as? NSNumber {
                    statsDict[Stats.Keys.Healing] = healing
                }
                if let strength = stats[ResponseKeys.StatsKeys.Strength] as? NSNumber {
                    statsDict[Stats.Keys.Strength] = strength
                }
                if let dexterity = stats[ResponseKeys.StatsKeys.Dexterity] as? NSNumber {
                    statsDict[Stats.Keys.Dexterity] = dexterity
                }
                if let vitality = stats[ResponseKeys.StatsKeys.Vitality] as? NSNumber {
                    statsDict[Stats.Keys.Vitality] = vitality
                }
                if let intelligence = stats[ResponseKeys.StatsKeys.Intelligence] as? NSNumber {
                    statsDict[Stats.Keys.Intelligence] = intelligence
                }
                if let primaryResource = stats[ResponseKeys.StatsKeys.PrimaryResource] as? NSNumber {
                    statsDict[Stats.Keys.PrimaryResource] = primaryResource
                }
                if let secondaryResource = stats[ResponseKeys.StatsKeys.SecondaryResource] as? NSNumber {
                    statsDict[Stats.Keys.SecondaryResource] = secondaryResource
                }
                result[Hero.Keys.Stats] = statsDict
            }
            
            // Items
            if let items = heroProfile[ResponseKeys.Items] as? [String: [String: AnyObject]] {
                var itemsArray = [[String: AnyObject]]()
                for (slotKey, itemValues) in items {
                    var itemDict = decodeBasicItem(itemValues)
                    itemDict[BasicItem.Keys.Slot] = slotKey
                    itemsArray.append(itemDict)
                }
                result[Hero.Keys.Items] = itemsArray
            }
            return result
        }
        return nil
    }
    
    class func decodeItemData(deserializeData: AnyObject) -> [String: AnyObject]? {
        if let itemData = deserializeData as? [String: AnyObject] {
            var result = [String: AnyObject]()
            if let id = itemData[ResponseKeys.ItemKeys.ID] as? String {
                result[DetailItem.Keys.ID] = id
            }
            if let name = itemData[ResponseKeys.ItemKeys.Name] as? String {
                result[DetailItem.Keys.Name] = name
            }
            if let icon = itemData[ResponseKeys.ItemKeys.Icon] as? String {
                result[DetailItem.Keys.IconKey] = icon
            }
            if let displayColor = itemData[ResponseKeys.ItemKeys.DisplayColor] as? String {
                result[DetailItem.Keys.DisplayColor] = displayColor
            }
            if let tooltipParams = itemData[ResponseKeys.ItemKeys.TooltipParams] as? String {
                result[DetailItem.Keys.TooltipParams] = tooltipParams
            }
            if let setItemsEquipped = itemData[ResponseKeys.ItemKeys.SetItemsEquipped] as? [String] {
                result[DetailItem.Keys.SetItemsEquipped] = setItemsEquipped
            }
            if let requiredLevel = itemData[ResponseKeys.ItemKeys.RequiredLevel] as? NSNumber {
                result[DetailItem.Keys.RequiredLevel] = requiredLevel
            }
            if let itemLevel = itemData[ResponseKeys.ItemKeys.ItemLevel] as? NSNumber {
                result[DetailItem.Keys.ItemLevel] = itemLevel
            }
            if let accountBound = itemData[ResponseKeys.ItemKeys.AccountBound] as? Bool {
                result[DetailItem.Keys.AccountBound] = accountBound
            }
            if let flavorText = itemData[ResponseKeys.ItemKeys.FlavorText] as? String {
                result[DetailItem.Keys.Flavor] = flavorText
            }
            if let typeName = itemData[ResponseKeys.ItemKeys.TypeName] as? String {
                result[DetailItem.Keys.TypeName] = typeName
            }
            if let type = itemData[ResponseKeys.ItemKeys.Type] as? [String: AnyObject] {
                if let typeID = type[ResponseKeys.ItemKeys.TypeID] as? String {
                    result[DetailItem.Keys.TypeID] = typeID
                }
                if let twoHanded = type[ResponseKeys.ItemKeys.TypeTwoHanded] as? Bool {
                    result[DetailItem.Keys.TypeTwoHanded] = twoHanded
                }
            }
            if let damageRange = itemData[ResponseKeys.ItemKeys.DamageRange] as? String {
                result[DetailItem.Keys.DamageRange] = damageRange
            }
            if let armor = itemData[ResponseKeys.ItemKeys.Armor] as? [String: NSNumber] {
                if let minArmor = armor[ResponseKeys.ItemKeys.Min], let maxArmor = armor[ResponseKeys.ItemKeys.Max] {
                    result[DetailItem.Keys.Armor] = NSNumber(double: (minArmor.doubleValue + maxArmor.doubleValue) / 2)
                }
            }
            if let dps = itemData[ResponseKeys.ItemKeys.DPS] as? [String: NSNumber] {
                if let minDPS = dps[ResponseKeys.ItemKeys.Min], let maxDPS = dps[ResponseKeys.ItemKeys.Max] {
                    result[DetailItem.Keys.DPS] = NSNumber(double: (minDPS.doubleValue + maxDPS.doubleValue) / 2)
                }
            }
            if let attacksPerSecond = itemData[ResponseKeys.ItemKeys.AttacksPerSecond] as? [String: NSNumber] {
                if let minAPS = attacksPerSecond[ResponseKeys.ItemKeys.Min], let maxAPS = attacksPerSecond[ResponseKeys.ItemKeys.Max] {
                    result[DetailItem.Keys.AttacksPerSecond] = NSNumber(double: (minAPS.doubleValue + maxAPS.doubleValue) / 2)
                }
            }
            if let attacksPerSecondText = itemData[ResponseKeys.ItemKeys.AttacksPerSecondText] as? String {
                result[DetailItem.Keys.AttacksPerSecondText] = attacksPerSecondText
            }
            if let blockChance = itemData[ResponseKeys.ItemKeys.BlockChance] as? String {
                result[DetailItem.Keys.BlockChance] = blockChance
            }
            if let attributesRaw = itemData[ResponseKeys.ItemKeys.AttributesRaw] as? [String: AnyObject] {
                if let blockAmountMin = attributesRaw[ResponseKeys.ItemKeys.BlockAmountMin] as? [String: NSNumber], let blockAmountDelta = attributesRaw[ResponseKeys.ItemKeys.BlockAmountDelta] as? [String: NSNumber] {
                    if let min = blockAmountMin[ResponseKeys.ItemKeys.Min], max = blockAmountMin[ResponseKeys.ItemKeys.Max] {
                        result[DetailItem.Keys.BlockAmountMin] = NSNumber(float: (min.floatValue + max.floatValue) / 2)
                        if let deltaMin = blockAmountDelta[ResponseKeys.ItemKeys.Min], deltaMax = blockAmountDelta[ResponseKeys.ItemKeys.Max] {
                            result[DetailItem.Keys.BlockAmountMax] = NSNumber(float: (min.floatValue + max.floatValue) / 2 + (deltaMin.floatValue + deltaMax.floatValue) / 2)
                        }
                    }
                }
            }
            if let attributes = itemData[ResponseKeys.ItemKeys.Attributes] as? [String: [[String: AnyObject]]] {
                result[DetailItem.Keys.Attributes] = decodeItemAttributes(attributes)
            }
            if let gems = itemData[ResponseKeys.ItemKeys.Gems] as? [[String: AnyObject]] {
                var gemsArray = [[String: AnyObject]]()
                for gemDict in gems {
                    let gem = decodeGem(gemDict)
                    gemsArray.append(gem)
                }
                result[DetailItem.Keys.Gems] = gemsArray
            }
            if let itemSet = itemData[ResponseKeys.ItemKeys.ItemSet] as? [String: AnyObject] {
                var itemSetDict = [String: AnyObject]()
                if let name = itemSet[ResponseKeys.ItemKeys.SetKeys.Name] as? String {
                    itemSetDict[ItemSet.Keys.Name] = name
                }
                if let items = itemSet[ResponseKeys.ItemKeys.SetKeys.SetItems] as? [[String: AnyObject]] {
                    var itemsArray = [[String: AnyObject]]()
                    for itemDict in items {
                        let item = decodeBasicItem(itemDict)
                        itemsArray.append(item)
                    }
                    itemSetDict[ItemSet.Keys.Items] = itemsArray
                }
                if let slug = itemSet[ResponseKeys.ItemKeys.SetKeys.Slug] as? String {
                    itemSetDict[ItemSet.Keys.Slug] = slug
                }
                if let itemBonus = itemSet[ResponseKeys.ItemKeys.SetKeys.Bonus] as? [[String: AnyObject]] {
                    var bonusArray = [[String: AnyObject]]()
                    for bonusDict in itemBonus {
                        var bonus = [String: AnyObject]()
                        if let required = bonusDict[ResponseKeys.ItemKeys.SetKeys.BonusRequired] as? NSNumber {
                            bonus[SetBonus.Keys.Required] = required
                        }
                        if let attributes = bonusDict[ResponseKeys.ItemKeys.SetKeys.BonusAttributes] as? [String: [[String: AnyObject]]] {
                            bonus[SetBonus.Keys.Attributes] = decodeItemAttributes(attributes)
                        }
                        bonusArray.append(bonus)
                    }
                    itemSetDict[ItemSet.Keys.SetBonus] = bonusArray
                }
                result[DetailItem.Keys.ItemSet] = itemSetDict
            }
            return result
        }
        return nil
    }
    
    // MARK: - Decode item elements
    class func decodeBasicItem(itemDict: [String: AnyObject]) -> [String: AnyObject] {
        var result = [String: AnyObject]()
        if let id = itemDict[ResponseKeys.ItemKeys.ID] as? String {
            result[BasicItem.Keys.ID] = id
        }
        if let name = itemDict[ResponseKeys.ItemKeys.Name] as? String {
            result[BasicItem.Keys.Name] = name
        }
        if let icon = itemDict[ResponseKeys.ItemKeys.Icon] as? String {
            result[BasicItem.Keys.IconKey] = icon
        }
        if let displayColor = itemDict[ResponseKeys.ItemKeys.DisplayColor] as? String {
            result[BasicItem.Keys.DisplayColor] = displayColor
        }
        if let tooltipParams = itemDict[ResponseKeys.ItemKeys.TooltipParams] as? String {
            result[BasicItem.Keys.ToolTipParams] = tooltipParams
        }
        if let setItemsEquipped = itemDict[ResponseKeys.ItemKeys.SetItemsEquipped] as? [String] {
            result[BasicItem.Keys.SetItemsEquipped] = setItemsEquipped
        }
        return result
    }
    
    class func decodeItemAttributes(attributes: [String: [[String: AnyObject]]]) -> [[String: AnyObject]] {
        var result = [[String: AnyObject]]()
        for (category, value) in attributes {
            for oneAttribute in value {
                var attribute = [String: AnyObject]()
                attribute[ItemAttribute.Keys.Category] = category
                if let text = oneAttribute[ResponseKeys.ItemKeys.AttributeKeys.Text] as? String {
                    attribute[ItemAttribute.Keys.Text] = text
                }
                if let color = oneAttribute[ResponseKeys.ItemKeys.AttributeKeys.Color] as? String {
                    attribute[ItemAttribute.Keys.DisplayColor] = color
                }
                if let affixType = oneAttribute[ResponseKeys.ItemKeys.AttributeKeys.AffixType] as? String {
                    attribute[ItemAttribute.Keys.AffixType] = affixType
                }
                result.append(attribute)
            }
        }
        
        return result
    }
    
    class func decodeGem(gemDict: [String: AnyObject]) -> [String: AnyObject] {
        var result = [String: AnyObject]()
        if let item = gemDict[ResponseKeys.ItemKeys.GemKeys.Item] as? [String: AnyObject] {
            result[Gem.Keys.BasicItem] = decodeBasicItem(item)
        }
        if let isGem = gemDict[ResponseKeys.ItemKeys.GemKeys.IsGem] as? Bool {
            result[Gem.Keys.IsGem] = isGem
        }
        if let isJewel = gemDict[ResponseKeys.ItemKeys.GemKeys.IsJewel] as? Bool {
            result[Gem.Keys.IsJewel] = isJewel
        }
        if let jewelRank = gemDict[ResponseKeys.ItemKeys.GemKeys.JewelRank] as? NSNumber {
            result[Gem.Keys.JewelRank] = jewelRank
        }
        if let jewelSecondaryEffectUnlockRank = gemDict[ResponseKeys.ItemKeys.GemKeys.JewelSecondaryEffectUnlockRank] as? NSNumber {
            result[Gem.Keys.JewelSecondaryEffectUnlockRank] = jewelSecondaryEffectUnlockRank
        }
        if let attributes = gemDict[ResponseKeys.ItemKeys.GemKeys.Attributes] as? [String: [[String: AnyObject]]] {
            result[Gem.Keys.Attributes] = decodeItemAttributes(attributes)
        }
        return result
    }
}