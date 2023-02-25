#include "GUIManager.h"
#include "TestPage.h"

UI::GUIManager::GUIManager()
{
	m_index = 0;
}

void UI::GUIManager::Initialize(GLFWwindow* window)
{
	m_window = window;
	m_pages.push_back(new TestPage());

	for (auto page : m_pages)
		page->Initialize();
	m_index = 0;


	IMGUI_CHECKVERSION();
	ImGui::CreateContext();
	ImGuiIO& io = ImGui::GetIO();
	ImGui::StyleColorsDark();
	ImGui_ImplGlfw_InitForOpenGL(window, true);
	const char* glsl_version = "#version 130";
	ImGui_ImplOpenGL3_Init(glsl_version);

	io.Fonts->AddFontFromFileTTF("c:\\Windows\\Fonts\\msyh.ttc", 20.0f);

}

void UI::GUIManager::ExitManager()
{
	for (auto page : m_pages)
	{
		page->Destroy();
		delete page;
	}
	ImGui_ImplOpenGL3_Shutdown();
	ImGui_ImplGlfw_Shutdown();
	ImGui::DestroyContext();

}

void UI::GUIManager::ChangePage(int index)
{
}

void UI::GUIManager::Update()
{
	ImGui_ImplOpenGL3_NewFrame();
	ImGui_ImplGlfw_NewFrame();
	ImGui::NewFrame();

	m_pages[m_index]->Update();

	ImGui::Render();
	int display_w, display_h;
	glfwGetFramebufferSize(m_window, &display_w, &display_h);
	glViewport(0, 0, display_w, display_h);
	glClearColor(0,0,0,1);
	glClear(GL_COLOR_BUFFER_BIT);
	ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

}
