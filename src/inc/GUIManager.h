#pragma once

#include <string>
#include <vector>
#include <glad/glad.h>
#include "imgui/imgui.h"
#include "imgui/imgui_impl_glfw.h"
#include "imgui/imgui_impl_opengl3.h"
#include <GLFW/glfw3.h> 	
#include "Page.h"
namespace UI
{

	class GUIManager
	{
	public:
		GUIManager();

		void Initialize(GLFWwindow* window);
		void ExitManager();
		void ChangePage(int index);

		void Update();


		std::string m_errMsg;
		int m_index;
		std::vector<Page*> m_pages;
		GLFWwindow* m_window;
	};
}

