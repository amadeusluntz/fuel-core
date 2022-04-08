use std::sync::{Arc, Mutex};

use fuel_vm::prelude::{InterpreterError, ProgramState};
use fuel_vm::profiler::{ProfileReceiver, ProfilingData};

#[derive(Clone, Default)]
pub(crate) struct ProfilingOutput {
    pub(crate) data: Arc<Mutex<Option<ProfilingData>>>,
}

impl ProfileReceiver for ProfilingOutput {
    fn on_transaction(
        &mut self,
        _state: &Result<ProgramState, InterpreterError>,
        data: &ProfilingData,
    ) {
        let mut guard = self.data.lock().unwrap();
        assert!(
            guard.is_none(),
            "This VM instance has already ran a transaction"
        );
        *guard = Some(data.clone());
    }
}
