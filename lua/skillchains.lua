return {
    [1] =
        {
            [1] = {open="Impaction",close="Liquefaction",result="Liquefaction"},
            [2] = {open="Scission",close="Liquefaction",result="Liquefaction"},
            [3] = {open="Reverberation",close="Impaction",result="Impaction"},
            [4] = {open="Induration",close="Impaction",result="Impaction"},
            [5] = {open="Impaction",close="Detonation",result="Detonation"},
            [6] = {open="Compression",close="Detonation",result="Detonation"},
            [7] = {open="Scission",close="Detonation",result="Detonation"},
            [8] = {open="Liquefaction",close="Scission",result="Scission"},
            [9] = {open="Detonation",close="Scission",result="Scission"},
            [10] = {open="Transfixion",close="Reverberation",result="Reverberation"},
            [11] = {open="Scission",close="Reverberation",result="Reverberation"},
            [12] = {open="Reverberation",close="Induration",result="Induration"},
            [13] = {open="Induration",close="Compression",result="Compression"},
            [14] = {open="Transfixion",close="Compression",result="Compression"},
            [15] = {open="Compression",close="Transfixion",result="Transfixion"}
        },
    [2] = 
        {
            [1] = {open="Liquefaction",close="Impaction",result="Fusion"},
            [2] = {open="Distortion",close="Fusion",result="Fusion"},
            [3] = {open="Induration",close="Reverberation",result="Fragmentation"},
            [4] = {open="Gravitation",close="Fragmentation",result="Fragmentation"},
            [5] = {open="Detonation",close="Compression",result="Gravitation"},
            [6] = {open="Fusion",close="Gravitation",result="Gravitation"},
            [7] = {open="Transfixion",close="Scission",result="Distortion"},
            [8] = {open="Fragmentation",close="Distortion",result="Distortion"}
        },
    [3] = 
        {
            [1] = {open="Fusion",close="Fragmentation",result="Light"},
            [2] = {open="Gravitation",close="Distortion",result="Darkness"},
            [3] = {open="Light",close="Light",result="Double Light"},
            [4] = {open="Darkness",close="Darkness",result="Double Darkness"}
        }
}

--[[
Copyright © 2013-2014, Windower
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Windower nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Windower BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]
