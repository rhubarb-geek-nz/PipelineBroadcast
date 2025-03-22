// Copyright (c) 2025 Roger Brown.
// Licensed under the MIT License.

using System;
using System.Management.Automation;

namespace RhubarbGeekNz.PipelineBroadcast
{
    [Cmdlet(VerbsLifecycle.Invoke, "PipelineBroadcast")]
    sealed public class InvokePipelineBroadcast : PSCmdlet, IDisposable
    {
        [Parameter(Mandatory = true)]
        public ScriptBlock[] ScriptBlock;
        [Parameter(Mandatory = false)]
        public Object[][] ArgumentList;
        [Parameter(Mandatory = true, ValueFromPipeline = true)]
        public Object InputObject;
        [Parameter(Mandatory = false)]
        public SwitchParameter PassThru
        {
            get
            {
                return passThru;
            }

            set
            {
                passThru = value;
            }
        }

        private SteppablePipeline[] pipes;
        private bool passThru;

        protected override void BeginProcessing()
        {
            int i = ScriptBlock.Length;
            pipes = new SteppablePipeline[i];
            while (0 != i--)
            {
                if (ArgumentList != null && null != ArgumentList[i])
                {
                    pipes[i] = ScriptBlock[i].GetSteppablePipeline(CommandOrigin.Internal, ArgumentList[i]);
                }
                else
                {
                    pipes[i] = ScriptBlock[i].GetSteppablePipeline(CommandOrigin.Internal);
                }
            }
            foreach (var pipe in pipes)
            {
                pipe.Begin(true);
            }
        }

        protected override void ProcessRecord()
        {
            if (passThru)
            {
                WriteObject(InputObject);
            }

            foreach (var pipe in pipes)
            {
                foreach (var result in pipe.Process(InputObject))
                {
                    WriteObject(result);
                }
            }
        }

        protected override void EndProcessing()
        {
            foreach (var pipe in pipes)
            {
                pipe.End();
            }
        }

        public void Dispose()
        {
            if (pipes != null)
            {
                foreach (var pipe in pipes)
                {
                    if (pipe != null)
                    {
                        pipe.Dispose();
                    }
                }
            }
        }
    }
}
