/**
 *	@author			:	Justus van den Berg (jfwberg@gmail.com)
 *	@date			:	2020-12-21 22:00
 *	@description	:	Basic calculator class for LWC Testing
 *
 *	Copyright (c) 2021 Justus van den Berg, info@aloha-workbench.com
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
public with sharing class BasicCalculator {
    
	// Add
	public static Decimal add(Decimal a, Decimal b){
		return a+b;
	}
	
	// Subtract
	public static Decimal subtract(Decimal a, Decimal b){
		return a-b;
	}
	
	// Devide
	public static Decimal devide(Decimal a, Decimal b){
		return a/b;
	}
	
	// Multiple
	public static Decimal multiply(Decimal a, Decimal b){
		return a*b;
	}

}