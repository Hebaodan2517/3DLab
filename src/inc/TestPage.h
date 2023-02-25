#pragma once
#include "Page.h"

namespace UI
{
    class TestPage :
        public Page
    {
        void Initialize();
        void Destroy();
        void Update();

    protected:
        char buf[128];
        float f;
    };
}

