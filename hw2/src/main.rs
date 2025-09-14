use rand::{self, random_range};
use std::ops::Add;
use std::{
    collections::HashSet,
    fs::File,
    io::{self, Write},
    time::{Duration, Instant},
};

#[derive(Debug)]
struct Output<T> {
    indices: Option<(usize, usize, usize)>,
    values: Option<(T, T, T)>,
    operations: u32,
}

fn three_sum<T, A>(arr: A, target: T) -> Output<T>
where
    T: Add<Output = T> + PartialEq + Copy,
    A: AsRef<[T]>,
{
    let arr = arr.as_ref();
    let len = arr.len();
    if len < 3 {
        panic!("array length < 3")
    }
    let mut operations = 0;
    for i in 0..len {
        for ii in i + 1..len {
            for iii in ii + 1..len {
                operations += 1;
                if arr[i] + arr[ii] + arr[iii] == target {
                    return Output {
                        indices: Some((i, ii, ii)),
                        values: Some((arr[i], arr[ii], arr[iii])),
                        operations,
                    };
                }
            }
        }
    }
    return Output {
        indices: None,
        values: None,
        operations,
    };
}

const REPETITIONS: usize = 50;

fn generate_data(n: usize) -> Vec<i32> {
    let mut data = HashSet::with_capacity(n);
    while data.len() < n {
        let val = random_range(-(n as i32) * 100..(n as i32) * 100);
        data.insert(val);
    }

    data.into_iter().collect()
}

fn test(n: usize) -> (Duration, u32) {
    let mut times = Vec::with_capacity(REPETITIONS);
    let mut operationss = Vec::with_capacity(REPETITIONS);
    for _ in 0..REPETITIONS {
        let data = generate_data(n);
        let start = Instant::now();
        let operations = three_sum(data, 0).operations;
        let duration = start.elapsed();
        times.push(duration);
        operationss.push(operations);
    }
    let avg_time = times.into_iter().sum::<Duration>() / REPETITIONS as u32;
    let avg_operations = operationss.into_iter().sum::<u32>() / REPETITIONS as u32;
    (avg_time, avg_operations)
}

fn powers_of_two(n: usize) -> Vec<usize> {
    let mut result = Vec::with_capacity(n);
    let mut value = 50;

    for _ in 0..n {
        result.push(value);
        value *= 2;
    }

    result
}

fn main() -> io::Result<()> {
    let mut table = File::create("_table.typ")?;
    let mut csv = File::create("data.csv")?;

    writeln!(table, "#table(")?;
    writeln!(table, "columns: (auto, auto, auto, auto),")?;
    writeln!(table, "inset: 8pt,")?;
    writeln!(
        table,
        "table.header([*n*], [*Avg Time*], [*Avg Operations*], [*Growth Rate*]),"
    )?;

    writeln!(csv, "n,avg_time_ns,avg_operations,growth_rate")?;

    println!(
        "{:>20} {:>20} {:>20} {:>20}\n",
        "n", "avg_time", "avg_operations", "growth_rate"
    );

    let mut prev_time = 1f32;
    let mut first_iter = true;

    for n in powers_of_two(16) {
        let (avg_time, avg_operations) = test(n);
        let current_avg_time_ns = avg_time.as_nanos() as f32;
        let growth_rate = if first_iter {
            first_iter = false;
            0f32
        } else {
            current_avg_time_ns / prev_time
        };
        prev_time = current_avg_time_ns;
        writeln!(
            table,
            r#"  "{}", "{:?}", "{:?}", "{:?}", "#,
            n, avg_time, avg_operations, growth_rate
        )?;
        writeln!(
            csv,
            "{},{:?},{:?},{:?}",
            n,
            avg_time.as_nanos(),
            avg_operations,
            growth_rate
        )?;
        println!(
            "{n:>20} {:>20?} {:>20?} {:>20?}",
            avg_time, avg_operations, growth_rate
        );
    }

    writeln!(table, ")")?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[should_panic(expected = "array length < 3")]
    fn test_array_too_short() {
        let arr = vec![1, 2];
        three_sum(arr, 0);
    }

    #[test]
    fn test_no_solution() {
        let arr = vec![1, 2, 3, 4, 5];
        let result = three_sum(arr, 0);
        assert!(result.indices.is_none());
        assert!(result.values.is_none());
    }

    #[test]
    fn test_single_solution() {
        let arr = vec![-1, 0, 1];
        let result = three_sum(arr, 0);
        assert_eq!(result.values.unwrap(), (-1, 0, 1));
    }

    #[test]
    fn test_all_zeros() {
        let arr = vec![0, 0, 0, 0];
        let result = three_sum(arr, 0);
        assert_eq!(result.values.unwrap(), (0, 0, 0));
    }

    #[test]
    fn test_target_nonzero() {
        let arr = vec![1, 2, 3, 4, 5];
        let result = three_sum(arr, 9);
        let (a, b, c) = result.values.unwrap();
        assert_eq!(a + b + c, 9);
    }
}
