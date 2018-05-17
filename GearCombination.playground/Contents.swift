//: Playground - noun: a place where people can play

import UIKit

class GearCombinations {
	
	/// A number of cogs on front crank (where the rider pedals)
	var frontCogs: [Int] = [38, 30]
	
	/// A number of cogs on the rear cassette (on the wheel)
	var rearCogs: [Int] = [28, 23, 19, 16]
	
	/**
	The output ratio from the pedals to the rear wheel.
	
	tooth count on selected front cog / tooth count on selected rear cog
	*/
	var ratio: Double = 1.6
	
	/// The initial front cog for gear combination
	private(set) var initFrontCog: Int = 38
	
	/// The initial rear cog for gear combination
	private(set) var initRearCog: Int = 28
	
	/**
	This dictionary (Key:Value) stores all the gear combinations.
	
	The Key's format is front_cog-rear_cog. For example, "38-28"
	The Value is a ratio (front_cog/rear_cog). For example, 1.357
	*/
	private var combinations = [String:Double]()
	
	/**
	Initializes gear combinations with the provided cogs and ratio.
	
	- Parameters:
	- frontCogs: A number of cogs on front crank
	- rearCogs: A number of cogs on the rear cassette
	- ratio: The output ratio from the pedals to the rear wheel.
	
	- Returns: A gear combinations, custom built just for you.
	*/
	init(frontCogs: [Int], rearCogs: [Int], ratio: Double = 1.6) {
		self.frontCogs = frontCogs
		self.rearCogs = rearCogs
		self.ratio = ratio
		
		self.generateGearCombinations()
	}
	
	/**
	Reset the initial ratio.
	
	- Parameter ratio: The new output ratio.
	*/
	func resetRatio(ratio: Double) {
		self.ratio = ratio
	}
	
	/**
	Initializes a gear combination with the provided cogs.
	
	- Parameter frontCog: The front cog.
	- Parameter rearCog: The rear cog.
	*/
	func initialGearCombination(frontCog: Int, rearCog: Int) {
		initFrontCog = frontCog
		initRearCog = rearCog
	}
	
	/// Generate and store all the gear combinations
	func generateGearCombinations() {
		guard frontCogs.count > 0, rearCogs.count > 0 else {
			return
		}
		
		for fCog in frontCogs {
			for rCog in rearCogs {
				let key = "\(fCog)-\(rCog)"
				let aRatio = Double(fCog)/Double(rCog)
				combinations[key] = aRatio
			}
		}
	}
	
	/**
	Find the closest gear combination based on the initial ratio.
	
	- Returns: Return the gear combination providing the closest ratio
	*/
	func getTheClosestRatio() -> (String, Double) {
		var closestKey = "0-0"
		var closestRatio = 0.0
		
		guard combinations.count > 0 else {
			return (closestKey, closestRatio)
		}
		
		var minDiff = Double(INT_MAX)
		for (key, value) in combinations {
			if abs(ratio - value) < minDiff {
				minDiff = abs(ratio - value)
				closestRatio = value
				closestKey = key
			}
		}
		
		return (closestKey, closestRatio)
	}
	
	/// Format and output the gear combination based on the closest ratio
	func outputTheClosestRatio() {
		let (key, ratio) = getTheClosestRatio()
		outputCombination(cogsKey: key, ratio: ratio)
	}
	
	/**
	Generate the shift gear sequences from initial combination to the closest ratio combination
	
	- Returns: Return a gear shift sequences.
	*/
	func generateShiftGearSequences() -> [[String:Double]] {
		var gearSequences = [[String: Double]]()
		guard combinations.count > 0 else {
			return gearSequences
		}
		
		let initKey = "\(initFrontCog)-\(initRearCog)"
		let initRatio = self.combinations[initKey]
		guard let theInitRatio = initRatio else {
			print("The initial gear combinations have something wrong!")
			return gearSequences
		}
		gearSequences.append([initKey:theInitRatio])
		
		let (closestGear, _) = getTheClosestRatio()
		// The initial gear combination is already the cloest one
		if closestGear == initKey {
			return gearSequences
		}
		let frontRearCogs = closestGear.split(separator: "-")
		let bestFrontCog = frontRearCogs.first!
		let bestRearCog = frontRearCogs.last!
		
		// Here assume the rear cogs count always greater than the front cogs count
		for rCog in rearCogs {
			let key = "\(bestFrontCog)-\(rCog)"
			let aRatio = self.combinations[key]!
			gearSequences.append([key:aRatio])
			
			// Completely shifted to the closest ratio gear combination
			if bestRearCog == "\(rCog)" {
				break
			}
		}
		
		return gearSequences
	}
	
	// MARK: - Output helpers
	
	func outputShiftGearSequences() {
		let sequences = generateShiftGearSequences()
		guard sequences.count > 0 else {
			print("No shift gear!")
			return
		}
		var order = 0
		for dict in sequences {
			let key = dict.keys.first!
			let value = dict[key]!
			order += 1
			self.outputCombinationSequence(order: order, cogsKey: key, ratio: value)
		}
	}
	
	func outputCombination(cogsKey: String, ratio: Double) {
		let (strFrontCog, strRearCog, strRatio) = formatGearCombination(cogsKey: cogsKey, ratio: ratio)
		print("Front: \(strFrontCog), Rear: \(strRearCog), Ratio \(strRatio)")
	}
	
	func outputCombinationSequence(order: Int, cogsKey: String, ratio: Double) {
		let (strFrontCog, strRearCog, strRatio) = formatGearCombination(cogsKey: cogsKey, ratio: ratio)
		print("\(order) - F:\(strFrontCog) R:\(strRearCog) Ratio \(strRatio)")
	}
	
	func formatGearCombination(cogsKey: String, ratio: Double) -> (String, String, String) {
		let frontRearCogs = cogsKey.split(separator: "-")
		guard frontRearCogs.count == 2 else {
			print("The input cogsKey should follow the format 00-00")
			return ("", "", "")
		}
		let strRatio = String(format: "%.3f", ratio)
		return ("\(frontRearCogs.first!)", "\(frontRearCogs.last!)", "\(strRatio)")
	}
	
}

// MARK: - Test

let frontCogs = [38, 30]
let rearCogs = [28, 23, 19, 16]
var ratio = 1.6

// Case-1: Using ratio == 1.6
let gc = GearCombinations(frontCogs: frontCogs, rearCogs: rearCogs, ratio: ratio)
gc.outputTheClosestRatio()

// initial gear combination (F:38, R:28)
gc.initialGearCombination(frontCog: 38, rearCog: 28)
gc.outputShiftGearSequences()

print("----------------------------------------------------")

// Case-2: Using ratio == 1.4
gc.resetRatio(ratio: 1.4)
gc.outputTheClosestRatio()

// initial gear combination (F:38, R:28)
gc.outputShiftGearSequences()

print("----------------------------------------------------")

// Case-3: Change initial gear combination (F:38, R:23) and ratio = 1.2
gc.resetRatio(ratio: 1.2)
gc.initialGearCombination(frontCog: 38, rearCog: 23)
gc.outputTheClosestRatio()
gc.outputShiftGearSequences()

print("----------------------------------------------------")

/* Test Results

Front: 30, Rear: 19, Ratio 1.579
1 - F:38 R:28 Ratio 1.357
2 - F:30 R:28 Ratio 1.071
3 - F:30 R:23 Ratio 1.304
4 - F:30 R:19 Ratio 1.579
----------------------------------------------------
Front: 38, Rear: 28, Ratio 1.357
1 - F:38 R:28 Ratio 1.357
----------------------------------------------------
Front: 30, Rear: 23, Ratio 1.304
1 - F:38 R:23 Ratio 1.652
2 - F:30 R:28 Ratio 1.071
3 - F:30 R:23 Ratio 1.304
----------------------------------------------------

*/
