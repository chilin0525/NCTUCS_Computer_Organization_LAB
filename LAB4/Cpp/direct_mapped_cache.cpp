#include <bits/stdc++.h>
using namespace std;

struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(int cache_size, int block_size,const char* filename)
{
	unsigned int tag, index, x;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	cache_content *cache = new cache_content[line];
	
    //cout << "cache line: " << line << endl;
	cout<<"cache_size:"<<cache_size/K<<"k "<<"block_size:"<<block_size<<"(Bytes): ";

	for(int j = 0; j < line; j++)
		cache[j].v = false;
	
    FILE *fp = fopen(filename, "r");  // read file
	
	double miss_num=0,cnt=0;
	while(fscanf(fp, "%x", &x) != EOF)
    {
		++cnt;
		//cout  << x <<  endl;;
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		if(cache[index].v && cache[index].tag == tag){
			//cout<<index<<" ";
			cache[index].v = true;    // hit
		}
		else
        {
			cache[index].v = true;  // miss
			cache[index].tag = tag;
			++miss_num;
		}
	}
	//cout<<" miss: "<<miss_num<<" ";
	cout<<setprecision(10)<<miss_num/cnt*100<<"%"<<endl;
   // cout << "offset_bit: "<<offset_bit<<" index_bit: "<<index_bit<<endl;

	fclose(fp);

	delete [] cache;
}
	
int main()
{
	cout<<"ICACHE.txt"<<endl;
	// Let us simulate 4KB cache with 16B blocks
	FILE *fp = fopen("ICACHE.txt","r");
	const char *f="ICACHE.txt";
	for(int i=4;i<=256;i*=4){
		cout<<"*******************************************************************"<<endl;
		for(int j=4;j<=9;j++){
			simulate(i*K,pow(2,j),f);
		}
		cout<<"*******************************************************************"<<endl;
		cout<<endl;
	}
	fclose(fp);

	cout<<"================================================================="<<endl;
	cout<<"================================================================="<<endl;
	cout<<endl;


	cout<<"DCACHE.txt.txt"<<endl;
	FILE *fp2 = fopen("DCACHE.txt","r");
	const char *f2="DCACHE.txt";
	for(int i=4;i<=256;i*=4){
		cout<<"*******************************************************************"<<endl;
		for(int j=4;j<=9;j++){
			simulate(i*K,pow(2,j),f2);
		}
		cout<<"*******************************************************************"<<endl;
		cout<<endl;
	}
	fclose(fp2);

}
