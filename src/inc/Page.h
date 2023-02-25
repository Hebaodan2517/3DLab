#pragma once

#include <string>
#include <imgui/imgui.h>
#include "Scene.h"
namespace UI
{
	class UIManager;
	class Page
	{
	public:
		virtual void Initialize() {}
		virtual void Destroy() {}
		virtual void Update() = 0;
	protected:
		UIManager* m_manager;
		Scene* m_scene;

	};
};

