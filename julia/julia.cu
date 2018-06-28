#ifdef _MSC_VER
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#endif

#include "matsave.h"
#include "nr3plus.h"
using namespace std;
#define H2D cudaMemcpyHostToDevice
#define D2H cudaMemcpyDeviceToHost

__device__
Int julia(Int x, Int y, float scale, Int dim) {
	Int i;
	float jx = scale * (float)(x - dim/2)/(dim/2);
	float jy = scale * (float)(y - dim/2)/(dim/2);
	Complex c(-0.8, 0.15745);
	Complex a(jx, jy);

	for (i=0; i<200; i++) {
		a = a * a + c;
		if (abs(a) > 31.62)
			return 0;
	}
	return 1;
}

__global__
void kernel(Uchar *ptr, float scale, Int dim) {
	Int indxy, ind = blockIdx.x*blockDim.x + threadIdx.x;
	Int stride = blockDim.x*gridDim.x;
	Int x,y;
	for(indxy = ind; indxy < dim*dim; indxy += stride){
		x = indxy%dim; y = indxy/dim;
		Int juliaValue = julia( x, y, scale, dim);
		ptr[indxy] = (Uchar)(255*juliaValue);
	}
}

int main( void ) {
	Int dim = 1000;
	int i, img_size = dim*dim*sizeof(Uchar);
	float scale = 1.5;
	string str;
	MatUchar bitmap(dim, dim);
	Uchar *dev_bitmap;

	cudaMalloc( (void**)&dev_bitmap, img_size );

	for (i = 0; i < 150; ++i){
		scale *= 0.95;
		cout << "iteration: " << i << endl;
		kernel<<<320,32>>>(dev_bitmap, scale, dim);
		cudaMemcpy(bitmap[0], dev_bitmap, img_size, D2H);
		str = to_string(i);
		MATFile *pfile = matOpen(("Data/" + str + ".julia.mat").c_str(), "w");
		matsave(bitmap, "I", pfile);
		matClose(pfile);
	}

	cudaFree( dev_bitmap );
}
