#include <iostream>		
using namespace std;
#define GLEW_STATIC     
#include "Shader.h"
#include "Camera.h"
#include "GUIManager.h"

Camera cam(glm::radians(90.0f),8.0/6.0,100,0.1);
UI::GUIManager theManager;
void processInput(GLFWwindow* window)
{
	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
		glfwSetWindowShouldClose(window, true);

	static double lastTime = 0;
	double time = glfwGetTime();
	double deltaTime = time - lastTime;
	lastTime = time;
	float cameraSpeed = 5.0f; // adjust accordingly
	if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS)
		cam.Translate(glm::vec3(cameraSpeed* deltaTime, 0, 0));
	if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS)
		cam.Translate(glm::vec3(-cameraSpeed * deltaTime, 0, 0));
	if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS)
		cam.Translate(glm::vec3(0, 0, cameraSpeed * deltaTime));
	if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS)
		cam.Translate(glm::vec3(0, 0, -cameraSpeed * deltaTime));
	if (glfwGetKey(window, GLFW_KEY_Q) == GLFW_PRESS)
		cam.Translate(glm::vec3(0, -cameraSpeed * deltaTime, 0));
	if (glfwGetKey(window, GLFW_KEY_E) == GLFW_PRESS)
		cam.Translate(glm::vec3(0, cameraSpeed * deltaTime, 0));

}

void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
	glViewport(0, 0, width, height);
}

void mouse_callback(GLFWwindow* window, double xpos, double ypos)
{
	static double lastX = 400, lastY = 300;
	double sensitive = 0.003;

	cam.LookRotate(glm::vec2(sensitive*(lastX- xpos),sensitive*(lastY-ypos)));
	lastX = xpos;
	lastY = ypos;
}


GLFWwindow* createWindow()
{
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);


	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	//glfwWindowHint(GLFW_CENTER_CURSOR, GL_TRUE);
	glfwWindowHint(GLFW_SAMPLES, 4);
	GLFWwindow* window = glfwCreateWindow(1280, 720, "3DLab", NULL, NULL);
	if (window == NULL)
	{
		std::cout << "window creation error!" << endl;
		glfwTerminate();
		return NULL;
	}
	glfwMakeContextCurrent(window);
	glfwSwapInterval(1); // Enable vsync


	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		std::cout << "Failed to initialize GLAD" << std::endl;
		return NULL;
	}



	glViewport(0, 0, 1280, 720);
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
	glfwSetCursorPosCallback(window, mouse_callback);

	return window;
}

int main()
{
	glfwInit();

	auto window = createWindow();
	if (window == NULL)return -1;



	glEnable(GL_MULTISAMPLE);
	theManager.Initialize(window);
	while (!glfwWindowShouldClose(window))
	{
		processInput(window);

		theManager.Update();

		glfwSwapBuffers(window);
		glfwPollEvents();
	}
	theManager.ExitManager();
	glfwTerminate();
	return 0;
}

