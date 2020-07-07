#include <iostream>
#include <stdio.h>
#include <math.h>
#include <list>
#include <vector>
#include <cstring>
#include <iomanip>

using namespace std;

struct cache_content
{
	//bool v=false;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(int cache_size, int block_size, const char * file_name)
{   
    for(int i=1;i<=64;i*=2){
        //set number  is i
        
        FILE *fp = fopen(file_name, "r");  // read file
        unsigned int tag, index, x;

        int offset_bit = (int)log2(block_size);
        int index_bit = (int)log2(cache_size / (block_size*i));
        int line = cache_size >> (offset_bit);

        line=line>>(int)log2(i);

        list <cache_content> cache[line];
        int size_of_set= i; 

        //cout << "cache line: " << line << endl;
        cout << "cache size: " << cache_size/K << "K " << i <<"-way" << " Miss Rate: ";

        double count=0,miss=0,flag3=0;
        while(fscanf(fp, "%x", &x) != EOF){
    
            //cout<<x<<endl;
            index = (x >> offset_bit) & (line - 1);
            //cout<<index<<" ";
            tag = x >> (index_bit + offset_bit);
            bool flag=false;
            for(auto it=cache[index].begin();it!=cache[index].end();it++){
                if(it->tag == tag){
                    cache[index].insert(cache[index].begin(),*it);
                    it=cache[index].erase(it);
                    flag=true;
                    break;
                }
            }
            if(!flag){
                miss++;
                cache_content temp;
                temp.tag=tag;
                cache[index].push_front(temp);
                if(cache[index].size()>size_of_set)cache[index].pop_back();
            }
            ++count;
        }    
        fclose(fp);
       // cout<<"miss: "<<miss<<" ";
        cout<<setprecision(10)<<miss*100/count<<"%"<<endl;
       // cout << "offset_bit: "<<offset_bit<<" index_bit: "<<index_bit<<endl;
       // cout<<miss<<" "<<count<<" "<<flag3<<endl;
    }
    
}
	
int main()
{
	// Let us simulate 4KB cache with 16B blocks
    cout<<"radix"<<endl;            
    for(int i=4;i<=256;i*=4){
	    simulate(i * K, 64,"RADIX.txt");
        cout<<endl;
    }
    cout<<endl;
    cout<<"lu"<<endl;

    for(int i=4;i<=256;i*=4){
        simulate(i * K, 64,"LU.txt");
        cout<<endl;
    }

}
