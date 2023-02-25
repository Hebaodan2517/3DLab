#pragma once

#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>
#include <vector>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "Mesh.h"
#include <map>

class MeshFactory
{
public:

	void SmoothNormal(bool enable);

	bool LoadFromFile(Mesh& mesh,std::string filePath);
	
	void CreateCube(Mesh& mesh,glm::vec3 size);
	void CreateQuad(Mesh& mesh,glm::vec2 size);
	void CreateSphere(Mesh& mesh,float radius,int level);
protected:
	void processNode(Mesh& mesh,aiNode* node, const aiScene* scene);
	void processMesh(Mesh& mesh,aiMesh* ldMesh, const aiScene* scene);

protected:
	bool m_smoothNormal;
};

