function Use-KasFileWriteMutex {
    param (
        [scriptblock]$Action  # ScriptBlock representing the action that requires mutex protection
    )

    try {
        # Acquire the module-scoped mutex
        $script:KasFileWriteMutex.WaitOne()
        # Execute the action within the mutex lock
        & $Action
    } finally {
        # Always release the mutex
        $script:KasFileWriteMutex.ReleaseMutex()
    }
}
