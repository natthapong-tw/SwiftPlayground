/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest

// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html

class Person: Equatable {
  static func == (lhs: Person, rhs: Person) -> Bool {
    return lhs.name == rhs.name && lhs.apartment == rhs.apartment;
  }
  
  let name: String
  var apartment: Apartment?
  var creditCard: CreditCard?
  
  init(name: String) {
    self.name = name
    self.apartment = nil
    print("Initializing Person(\(name))")
  }
  
  init(name: String, apartment: Apartment) {
    self.name = name
    self.apartment = apartment
    print("Initializing Person(\(name), \(apartment.unit))")
  }
  
  deinit {
    print("Person\(name) is deinit.")
  }
  
  func setApartment(apartment: Apartment) {
    self.apartment = apartment
  }
  
  func setCreditCard(creditCard: CreditCard) {
    self.creditCard = creditCard
  }
}

class Apartment: Equatable {
  static func == (lhs: Apartment, rhs: Apartment) -> Bool {
    return lhs.tenent == rhs.tenent && lhs.unit == rhs.unit
  }
  
  let unit: String
  weak var tenent: Person?
  
  init(unit: String) {
    self.unit = unit
    self.tenent = nil
    print("Initializing Apartment(\(unit))")
  }
  
  init(unit: String, tenent: Person) {
    self.unit = unit
    self.tenent = tenent
    print("Initializing Apartment(\(unit), \(tenent.name))")
  }
  
  deinit {
    let optionalTenent = tenent.map { (foundTenent) -> String in
      return foundTenent.name
    } ?? ""
    print("Apartment \(unit) \(optionalTenent) was deinit")
  }
  
  func setTenent(tenent: Person) {
    self.tenent = tenent
  }
}

class CreditCard {
  let number: String
  unowned var owner: Person?
  
  init(number: String) {
    self.number = number
    self.owner = nil
  }
  
  deinit {
    print("CreditCard deinit(\(number)")
  }
  
  func setOwner(owner: Person) {
    self.owner = owner
  }
}

class MemoryManagementTests: XCTestCase {
  
  func testReferenceCounting() {
    var ref1: Person? = Person(name: "John")
    var ref2: Person? = ref1
    var ref3: Person? = ref1
    weak var ref4: Person? = ref1
    
    print("0")
    ref1 = nil
    print("1")
    ref2 = nil
    print("2")
    print("ref4 = \(ref4)")
    print("ref3 = \(ref3)")
    ref3 = nil
    print("3")
    print("ref4 = \(ref4)")
  }
  
  func testAssociatePersonWithApartmentShouldWorkCorrectly() {
    let personName = "John"
    let unitName = "A88"
    let person: Person = Person(name: personName)
    let apartment: Apartment = Apartment(unit: unitName)
    
    person.setApartment(apartment: apartment)
  }
    
  func testInitialization() {
    var person: Person? = Person(name: "Junior")
    print("Before set person to nil")
    person = nil;
    print("After set person to nil")
  }
  
}
