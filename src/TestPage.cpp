#include "TestPage.h"

void UI::TestPage::Initialize()
{
}

void UI::TestPage::Destroy()
{
}

void UI::TestPage::Update()
{
	ImGui::Text("Hello, world %d", 123);
	ImGui::Button("Save");
	ImGui::InputText("string", buf, 128);
	ImGui::SliderFloat("float", &f, 0.0f, 1.0f);
}
