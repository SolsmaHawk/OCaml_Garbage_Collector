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
let free_pointer = 0;;

let copy_obj (free : int) (addr : int) =   (* Explicit type casting - Just for one object? Copies an object to the To-space. How to access To-space? *)
	match ram.(addr) with
	| FwdPointer value -> (free,value)
	| Object (_, size, _) -> 
			for num = 1 to size do
  				ram.(to_space+free+num-1) <- ram.(addr+num-1);
					ram.(addr+num-1) <- FwdPointer (to_space+free+num-1);
			done; ((free+size),free) (*returns updated free pointer and new address of the object*)
	| _ -> (0,0);;



(*ram.(to_space+free) <- ram.(addr); ram;
ram.(addr) <- FwdPointer addr; ram;;
add forwarding pointer in place of moved object*)

(*ram[to_space+free]=ram[addr]
ram in ram.(to_space+free) <- ram in ram.(addr); ram;;
# let a = [| 1; 2 ;3 |] in a.(1) <- 0; a;;
- : int array = [|1; 0; 3|]
*)
	
(* The function scan_tospace is recursive, ideally tail-recursive, 
	 and takes as arguments the next free memory location in the 
	 To-space (free), and the location of the first unscanned object in the 
	 To-space (unscanned). It checks all references of the object, 
	 updates them with references in the To-space by either copying
	 the referenced object, or reading the forwarding pointer. 
	 Use the copy obj function. Terminate and return the free pointer,
 	 if the unscanned pointer is equal to it.
	 
	 Scan To-space, copy all referenced objects to the To-space and
   update references in objects. Recurse until the free pointer is
   identical to the unscanned pointer.

   [free] is the pointer to the next free address in the To-space,
   [unscanned] is the address of the first unscanned object in the
   To-space.

   Return the address of the free pointer after all objects have been
   scanned.
	
	
let rec find trie keys = 

		match keys with
		| [] -> words(trie)
    	|head::tail -> find (trie_of_key trie head)(tail);;

*)
let rec scan_tospace (free : int) (unscanned : int) =  (* Uses copy_obj recursively? *)
	match ram.(to_space+free) with
	| ObjData _ -> scan_tospace (free+1) (unscanned+1)
	| Free ->scan_tospace (free+1) (unscanned+1)
	| FwdPointer _ ->scan_tospace (free+1) (unscanned+1)
	| Object (_, _, refs) ->
		match refs with
		| [] -> 0
		| h :: t -> copy_obj unscanned h; scan_tospace (free+1) (unscanned+1);;


(*
  Garbage collect with given root set. Copy all reachable objects in
   the From-space to the To-space, update references in objects and
   keep the To-space compact without holes between objects. 

   [root_set] is a list of references into the From-space

   Return the new addresses in the To-space of the objects in the root
   set.
*)
(*copy_obj (free : int) (addr : int)

let rec copy_root_set root (free,other) = 
	match root with
  | [] -> 0
  | h :: t -> copy_root_set t (copy_obj free h); 5;;
*)

let copy_gc (root_set : int list) = raise Missing;;
 	copy_obj 0 0;
	copy_obj 4 2; [0; 2]
(*	scan_tospace to_space (to_space+1);;*)

(*copy_root_set root_set (to_space,0);;

First: use copy_obj to copy items from root_set to to_space*)
(* Second: Use scan_tospace to copy over referenced objects and update references*)
(* copy_obj (copy_obj 0 (List.nth root_set 0)) (List.nth root_set 1);; 
	
	for num = 0 to (List.length root_set) do
		copy_obj (to_space+num) (List.nth root_set num)
	done; (12);;
		
    copy_obj 2 3;;*)
