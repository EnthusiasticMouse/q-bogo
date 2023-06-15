namespace bogosort {

    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation arrayGen() : Int[]{
        mutable myArray = [];
        mutable myNum = [];
        use q = Qubit();
        for i in 0..7{
            set myArray += [ResultArrayAsInt(myNum)];
            set myNum = [];
            for j in 0..7{
                H(q);
                set myNum += [M(q)];
            }
        }
        return myArray;
    }
    operation arrayShuffle(arr : Int[]) : Int[]{
        mutable newArray = arr;
        mutable myNum = [];
        mutable temp = 0;
        use q = Qubit();
        for i in 0..7{ // creates 8 random 4 bit numbers puts in myNum
            set myNum = [];
            for j in 0..2{ // randomises 3 bits to create a  3 bit number
                H(q);
                set myNum += [M(q)];
            }
            mutable newIndex = ResultArrayAsInt(myNum); // converts the 3 bit number to an index
            set temp = newArray[newIndex]; 
            set newArray w/= newIndex <- newArray[i];
            set newArray w/= i <- temp;
        }
        return newArray;
    }
    operation printArray(arr : Int[]) : Unit{
        Message("Array: ");
        for i in 0..7{
            Message(IntAsString(arr[i]));
        }
        Message("------------------");
    }
    operation checkSorted(arr : Int[]) : Bool{
        for i in 0..6{
            if(arr[i] > arr[i+1]){
                return false;
            }
        }
        return true;
    }
    @EntryPoint()
    operation SayHello() : Int[] {
        mutable myArray = arrayGen();
        printArray(myArray);
        mutable sorted = false;
        repeat{
            set myArray = arrayShuffle(myArray);
            if(checkSorted(myArray)){
                set sorted = true;
            }
        }
        until(sorted);
        return myArray;
        //return arrayShuffle(myArray);
    }
}
