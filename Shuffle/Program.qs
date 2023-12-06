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
}

