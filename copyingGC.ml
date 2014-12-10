open Memory

(* 
	The first function copy obj copies the object at addr to free, 
	unless it is a forwarding pointer. In the first case, it returns 
	an updated free pointer, and the new 	address of the object. 
	It must copy the whole object as of its size. If the object is a 
	forwarding pointer, it returns the free pointer unchanged and 
	value of the forwarding pointer.

	Copy an object to the To-space or return its address. Modify the
   object in the From-space to contain a forwarding pointer to the new
   address. Copy the whole object, that is, the number of memory cells
   determined by the size of the object.

   [free] is the pointer to the next free address in the To-space,
   [addr] is the address of the object to copy. 

   Return a pair of addresses, the first is the updated [free]
   pointer, the second is the new address of the object. 





let rec print_list = function 
[] -> ()
| e::l -> pp_print_cell e ; print_string " " ; print_list l;;
*)


(*print_ram();;*)

let to_space = ram_size / 2;;

let copy_obj (free : int) (addr : int) =   (* Explicit type casting - Just for one object? Copies an object to the To-space. How to access To-space? *)
	match ram.(addr) with
	| FwdPointer value -> (free,value)
	| Object (_, size, _) -> 
			for num = 1 to size do
  				ram.(to_space+free+num-1) <- ram.(addr+num-1); ram;
					ram.(addr+num-1) <- FwdPointer (to_space+free+num-1); ram;
			done; ((free+size+1),free)
	| _ -> (0,0);;



(*ram.(to_space+free) <- ram.(addr); ram;
ram.(addr) <- FwdPointer addr; ram;;
add forwarding pointer in place of moved object*)

(*ram[to_space+free]=ram[addr]
ram in ram.(to_space+free) <- ram in ram.(addr); ram;;
# let a = [| 1; 2 ;3 |] in a.(1) <- 0; a;;
- : int array = [|1; 0; 3|]
*)
	
(* Scan To-space, copy all referenced objects to the To-space and
   update references in objects. Recurse until the free pointer is
   identical to the unscanned pointer.

   [free] is the pointer to the next free address in the To-space,
   [unscanned] is the address of the first unscanned object in the
   To-space.

   Return the address of the free pointer after all objects have been
   scanned.

*)
let rec scan_tospace (free : int) (unscanned : int) = raise Missing (* Uses copy_obj recursively? *)


(* Garbage collect with given root set. Copy all reachable objects in
   the From-space to the To-space, update references in objects and
   keep the To-space compact without holes between objects. 

   [root_set] is a list of references into the From-space

   Return the new addresses in the To-space of the objects in the root
   set.
*)
let copy_gc (root_set : int list) = raise Missing
   (* copy_obj 2 3;;*)
