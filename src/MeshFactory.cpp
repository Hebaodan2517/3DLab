#include "MeshFactory.h"

void MeshFactory::SmoothNormal(bool enable)
{
	m_smoothNormal = enable;
}

void MeshFactory::CreateCube(Mesh& mesh, glm::vec3 size)
{

}

void MeshFactory::CreateQuad(Mesh& mesh, glm::vec2 size)
{
}

void MeshFactory::CreateSphere(Mesh& mesh, float radius, int level)
{
}

bool MeshFactory::LoadFromFile(Mesh& mesh, std::string filePath)
{
	Assimp::Importer importer;
	const aiScene* scene = importer.ReadFile(filePath, aiProcess_Triangulate | aiProcess_FlipUVs);
	if (scene == nullptr || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE || !scene->mRootNode)
	{
		std::cout << "ERROR::ASSIMP::" << importer.GetErrorString() << std::endl;
		return false;
	}
	processNode(mesh,scene->mRootNode, scene);
	
	mesh.buildBVH(3);
	mesh.loadBufferData();

	return true;
}


void MeshFactory::processNode(Mesh& mesh,aiNode* node, const aiScene* scene)
{
	for (unsigned int i = 0; i < node->mNumMeshes; i++)
	{
		aiMesh* amesh = scene->mMeshes[node->mMeshes[i]];
		processMesh(mesh,amesh, scene);
	}
	for (unsigned int i = 0; i < node->mNumChildren; i++)
		processNode(mesh,node->mChildren[i], scene);
}

void MeshFactory::processMesh(Mesh& mesh, aiMesh* ldMesh, const aiScene* scene)
{
	int offset = mesh.m_vertices.size();
	for (unsigned int i = 0; i < ldMesh->mNumVertices; ++i)
	{
		mesh.m_vertices.push_back(
			glm::vec3(ldMesh->mVertices[i].x, ldMesh->mVertices[i].y, ldMesh->mVertices[i].z));
		if (ldMesh->mNormals)
			mesh.m_normals.push_back(
				glm::vec3(ldMesh->mNormals[i].x, ldMesh->mNormals[i].y, ldMesh->mNormals[i].z));
		else
			mesh.m_normals.push_back(glm::vec3(0));
	}
	std::vector<unsigned int> indices;

	for (unsigned int i = 0; i < ldMesh->mNumFaces; i++)
	{
		aiFace& face = ldMesh->mFaces[i];
		for (unsigned int j = 0; j < face.mNumIndices;)
		{
			Mesh::Triangle triangle;
			for (int k = 0; k < 3; ++k)
				triangle.vind[k] = face.mIndices[j++];
			mesh.m_triangles.push_back(triangle);
		}
	}
}
