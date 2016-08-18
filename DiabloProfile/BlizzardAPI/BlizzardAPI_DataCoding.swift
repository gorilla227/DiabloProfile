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
            return result
        }
        return nil
    }
}