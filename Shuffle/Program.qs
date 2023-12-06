namespace QSharp.Shuffle {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    @EntryPoint()
    operation Main() : Unit {
        let array = MappedOverRange(i -> i, 0..10);
        Message($"Ordered array: {array}");

        let shuffled = Shuffled(array);
        Message($"Shuffled array: {shuffled}");

        let balancedBoolArray1 = BoolArrayWithEqualDistributionV1(8);
        Message($"Balanced bool array V1: {balancedBoolArray1}");

        let balancedBoolArray2 = BoolArrayWithEqualDistributionV2(8);
        Message($"Balanced bool array V2: {balancedBoolArray2}");
    }

    operation Shuffled<'T>(array : 'T[]) : 'T[] {
        let n = Length(array);
        mutable shuffled = array;

        for i in 0..n - 2 {
            let j = DrawRandomInt(i, n - 1);
            set shuffled = Swapped(i, j, shuffled);
        }

        return shuffled;
    }

    operation BoolArrayWithEqualDistributionV1(size: Int) : Bool[] {
        mutable trueCount = 0;
        mutable falseCount = 0;
        mutable resultArray = [false, size = size];

        Fact(size % 2 == 0, "Size must be divisible by 2");
        let halfSize = size / 2;

        for i in 0..size - 1 {
            if trueCount < halfSize and falseCount < halfSize {
                let randomBit = DrawRandomBool(0.5);
                if (randomBit) {
                    set trueCount = trueCount + 1;
                } else {
                    set falseCount = falseCount + 1;
                }
                set resultArray w/= i <- randomBit;
            }
            elif trueCount >= halfSize {
                set resultArray w/= i <- false;
            }
            else {
                set resultArray w/= i <- true;
            }
        }

        return resultArray;
    }

    operation BoolArrayWithEqualDistributionV2(size: Int) : Bool[] {
        Fact(size % 2 == 0, "Size must be divisble by 2");
        
        let array = [true, size = size/2];
        return Shuffled(Padded(-size, false, array));
    }
}

